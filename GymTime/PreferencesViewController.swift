//
//  PreferencesViewController.swift
//  GymTime
//
//  Copyright © 2017 Laura Rundle. All rights reserved.
//  This Controller represents the "Preferences" Screen
import UIKit
import Foundation
import EventKit
import Firebase


class PreferencesViewController: UIViewController{
    
    var dateFormatter =  DateFormatter()
    
    @IBOutlet weak var todayPreferenceSwitch: UISwitch!
   
    @IBOutlet weak var saveFeedback: UILabel!
    
    @IBOutlet weak var weekendPreferenceSwitch: UISwitch!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    
    //These integers were set according to how the gym data is categorised and the capacity of the gym. e.g. <40 is considered good therefore if 35 people go at this time it will not be considered good any more. This will be removed as the author implemented future work with alternative data
    let good = 35
    let medium = 23
    let busy = 10
    
    var EventArray = [EventDetails]()
    
    @IBOutlet weak var mustGivePermissionLabel: UILabel!
    
    let reference = FIRDatabase.database().reference()
  
    
    var todayDate = NSDate()
    let unitFlags = Set<Calendar.Component>([.hour, .day, .weekday, .month])
    
    //save user preferences in the database and provide feedback to the user that this has happened
    @IBAction func savePreferencesButton(_ sender: Any) {
        
        saveFeedback.isHidden = false
        
        if(todayPreferenceSwitch.isOn == true)
        {
            ThisWeek.Instance.includeToday = true
            
        }
        else
        {
            ThisWeek.Instance.includeToday = false
        }
        if(weekendPreferenceSwitch.isOn == true)
        {
            ThisWeek.Instance.includeWeekend = true
        }
        else
        {
            ThisWeek.Instance.includeWeekend = false
        }
        let user = FIRAuth.auth()?.currentUser
        
        let ref = FIRDatabase.database().reference()
        ref.child("Preferences").child((user?.uid)!).setValue(["today" : ThisWeek.Instance.includeToday, "weekend" : ThisWeek.Instance.includeWeekend])
        
        let delay = 0.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay)
        {
            self.saveFeedback.isHidden = true
        }
        
        
        
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        saveFeedback.isHidden = true
        initialisePreferenceSwitch()
        ActivityIndicator.hidesWhenStopped = true
        continueButton.isEnabled = false
        continueButton.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        ActivityIndicator.startAnimating()
        ThisWeek.Instance.getMonth()
        checkAuthorisation()
        
        //if the user has not granted permission, present an error message describing how they can fix the error and keep the continue button disabled to stop the user progressing
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if (status != EKAuthorizationStatus.authorized)
        {
            self.mustGivePermissionLabel.text = "GymTime needs access to your calendar to get the best times for you. Go to Settings -> GymTime and enable the Calendar switch."
            self.ActivityIndicator.stopAnimating()
        }
        else
        {
            
            if(ThisWeek.Instance.loadDatabase == true)
            {
                getEvents()
                fillInTimeTable()
                determineWhatTimesHaveAlreadyPassed()
                findBestTime()
                ThisWeek.Instance.loadDatabase = false
                let delay = 3.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay)
                {
                    print(ThisWeek.Instance.personalisedTimesArray)
                    self.ActivityIndicator.stopAnimating()
                    self.continueButton.isEnabled = true
                }
            }
            else
            {
                self.ActivityIndicator.stopAnimating()
                self.continueButton.isEnabled = true
            }
        }
        
    }

    
    
   
    @IBAction func logoutButton(_ sender: Any) {
        
        var user = FIRAuth.auth()?.currentUser
        print("logout pressed")
        print(user?.email! ?? "none")
        try! FIRAuth.auth()!.signOut()
        user = FIRAuth.auth()?.currentUser
        print(user?.email! ?? "none")
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    
   
  
    @IBAction func includeWeekendSwitch(_ sender: UISwitch) {
        
        if(sender.isOn)
        {
            ThisWeek.Instance.includeWeekend = true
        }
        else
        {
            ThisWeek.Instance.includeWeekend = false
        }
    }
    
    @IBAction func includeTodaySwitch(_ sender: UISwitch) {
        
        if(sender.isOn)
        {
            ThisWeek.Instance.includeToday = true
        }
        else
        {
            ThisWeek.Instance.includeToday = false
        }

    }
    
    
    
    //use the database information to set the preferences to the last saved values
    func initialisePreferenceSwitch()
    {
        let user = FIRAuth.auth()?.currentUser
        let ref = reference.ref
        
        ref.child("Preferences").child((user?.uid)!).child("today").observeSingleEvent(of: .value, with: { (snapshot) in
            let boolToReturn = snapshot.value as? Bool ?? true
            ThisWeek.Instance.includeToday = boolToReturn
            self.todayPreferenceSwitch.isOn = boolToReturn
        })
        
        ref.child("Preferences").child((user?.uid)!).child("weekend").observeSingleEvent(of: .value, with: { (snapshot) in
            let boolToReturn = snapshot.value as? Bool ?? true
            ThisWeek.Instance.includeWeekend = boolToReturn
            self.weekendPreferenceSwitch.isOn = boolToReturn
        })
    }
    
    func checkAuthorisation()
    {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            print ("not Determined")
            alertTheUser()
        case EKAuthorizationStatus.authorized:
            print("authorised")
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("restricted")
            alertTheUser()
        }
    }
    //if the user has not granted permission they are presented with an alert that brings them to the Settings page so they can grant access to Calendar
    func alertTheUser()
    {
        let alert = UIAlertController(title: "GymTime needs permission",
                                      message: "GymTime needs access to your calendar in order to tell you the best time for you",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go To Settings", style: .default, handler: { action in
            let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    
    //This function retrieves the events from the user's Calendar, creates an event object and stores the object in an array
    func getEvents()
    {
        let eventStore: EKEventStore = EKEventStore()
        let endDate = NSDate().addingTimeInterval(60*60*24*7)
        
        print(dateFormatter.string(from: todayDate as Date))
        
        let predicate = eventStore.predicateForEvents(withStart: todayDate as Date, end: endDate as Date, calendars: nil)
        
        let eventVar = eventStore.events(matching: predicate) as [EKEvent]!
        
        if eventVar != nil {
            
            for i in eventVar! {
                print("Title  \(i.title)" )
                print("startDate: \(i.startDate)" )
                print("endDate: \(i.endDate)" )
                
                let duration = i.endDate.timeIntervalSince(i.startDate as Date)
                if(i.isAllDay == false)
                {
                    EventArray.append(EventDetails(startDate: i.startDate, endDate: i.endDate, duration: Int(duration)))
                }
                
            }
        }
    }
    
    //the event duration is retrieved in seconds and the following two functions convert seconds to minutes and then hours respectively
    func durationConversionToMinutes(second: Int) -> Int {
        let minutes = second / 60
        return minutes
    }
    
    func durationConversionToHours(minute: Int) -> Int {
        
        var hour = minute/60
        if(minute % 60 > 0)
        {
            //based on the assumptions made, if the event is less than an hour the entire hour is marked as unavailable
            hour = hour + 1
        }
        return hour
    }
    
    //this function uses the events to determine when the user is free
    func fillInTimeTable()
    {
        
        for i in 0..<EventArray.count
        {
            print(EventArray[i].startDate)
            var components = NSCalendar.current.dateComponents(unitFlags, from: EventArray[i].startDate as Date)
            var hour = Int(components.hour!)
            
            let flags = Set<Calendar.Component>([.day])
            let date1 = NSCalendar.current.startOfDay(for: EventArray[i].startDate)
            let date2 = NSCalendar.current.startOfDay(for: NSDate() as Date)
            var numberOfDays = NSCalendar.current.dateComponents(flags, from: date2, to: date1)
      
            let durationMinutes = durationConversionToMinutes(second: EventArray[i].duration)
            let durationHours = durationConversionToHours(minute: durationMinutes)
           
            
            //if the event is during the Gym's opening hours
            //ASSUMPTION: user needs an hour to work out and gym closes at 22:00 so only checks events up until 21:00
            
            if(hour <= 21)
            {
                switch(numberOfDays.day!) //CASE 0 represents today, CASE 1 represents tomorrow and so on
                {
                case 0:
                    for _ in 1...durationHours
                    {
                        if(hour - 7 >= 0 && hour < 22)
                        {
                            ThisWeek.Instance.One[hour-7] = "busy"
                        }
                        hour = hour + 1
                    }
                case 1:
                    for _ in 1...durationHours
                    {
                        if(hour - 7 >= 0 && hour < 22)
                        {
                            ThisWeek.Instance.Two[hour-7] = "busy"
                        }
                        hour = hour + 1
                    }
                case 2:
                    for _ in 1...durationHours
                    {
                        if(hour - 7 >= 0 && hour < 22)
                        {
                             ThisWeek.Instance.Three[hour-7] = "busy"
                        }
                        hour = hour + 1
                    }
                case 3:
                    for _ in 1...durationHours
                    {
                        if(hour - 7 >= 0 && hour < 22)
                        {
                            ThisWeek.Instance.Four[hour-7] = "busy"

                        }
                        hour = hour + 1
                    }
                case 4:
                    for _ in 1...durationHours
                    {
                        if(hour - 7 >= 0 && hour < 22)
                        {
                            ThisWeek.Instance.Five[hour-7] = "busy"
                        }
                        
                        hour = hour + 1
                    }
                case 5:
                    for _ in 1...durationHours
                    {
                        if(hour - 7 >= 0 && hour < 22)
                        {
                            ThisWeek.Instance.Six[hour-7] = "busy"
                        }
                        hour = hour + 1
                    }
                case 6:
                    for _ in 1...durationHours
                    {
                        if(hour - 7 >= 0 && hour < 22)
                        {
                            ThisWeek.Instance.Seven[hour-7] = "busy"
                        }
                        
                        hour = hour + 1
                    }
                case 7:
                    print(numberOfDays.day!)
                default:
                    print("ERROR ERROR ERROR")
                    print(hour-7)
                    print(numberOfDays.day!)
                }
            }
        }
        
        print("TIMETABLES")
        
        printTimeTables(array: ThisWeek.Instance.One)
        printTimeTables(array: ThisWeek.Instance.Two)
        printTimeTables(array: ThisWeek.Instance.Three)
        printTimeTables(array: ThisWeek.Instance.Four)
        printTimeTables(array: ThisWeek.Instance.Five)
        printTimeTables(array: ThisWeek.Instance.Six)
        printTimeTables(array: ThisWeek.Instance.Seven)
    }
    
    
    //the user should not be suggested times that have already gone past, this function deals with that
    func determineWhatTimesHaveAlreadyPassed()
    {
        var components =  NSCalendar.current.dateComponents(unitFlags, from: todayDate as Date)
        
        let hour = Int(components.hour!)
        print(hour)
        
        if(hour >= 7)
        {
            for i in 7...hour
            {
                
                if(i <= 21 )
                {
                    ThisWeek.Instance.One[i-7] = "not available"
                }
 
            }
        }
        printTimeTables(array: ThisWeek.Instance.One)
    }
    
    func printArray()
    {
        print(EventArray)
    }
    func printTimeTables(array: [String])
    {
        for index in 0...14
        {
            print(array[index])
        }
        
        print("*******************")
    }
    
    
    //this function uses the free times information and gym information in the database to determine when the user should go to the gym
    //when a suitable time is found, a PersonalisedTimes object is created and stored in an array.
    func findBestTime()
    {
        var start = NSDate()
        let dayCounter = 7
        
        for i in 1...dayCounter
        {
            print(start)
            let day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
            let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
            let dateVar = String(day.day!)
            
            for index in 0...ThisWeek.Instance.One.count - 1
            {
                let tempTime = index + 7
                let tempTimeAsString = String(tempTime)
                
                self.getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                    
                    self.numPeopleGoing(date: dateVar, time: tempTimeAsString, completion: { (intToReturn) in
                        
                        switch(i)
                        {
                        case 1:
                            if(ThisWeek.Instance.One[index] == "free" && ((stringToReturn == "good" && intToReturn <= self.good) || (stringToReturn == "medium" && intToReturn <= self.medium) || (stringToReturn == "busy" && intToReturn <= self.busy)))
                            {
                                let x = PersonalisedTimes(date: day.day!, day: tempDay, time: tempTimeAsString, status: stringToReturn, tracker: intToReturn)
                                ThisWeek.Instance.personalisedTimesArray.append(x)
                            }
                        case 2:
                            if(ThisWeek.Instance.Two[index] == "free" && ((stringToReturn == "good" && intToReturn <= self.good) || (stringToReturn == "medium" && intToReturn <= self.medium) || (stringToReturn == "busy" && intToReturn <= self.busy)))
                            {
                                let x = PersonalisedTimes(date: day.day!, day: tempDay, time: tempTimeAsString, status: stringToReturn,tracker: intToReturn)
                                ThisWeek.Instance.personalisedTimesArray.append(x)
                            }
                        case 3:
                            if(ThisWeek.Instance.Three[index] == "free" && ((stringToReturn == "good" && intToReturn <= self.good) || (stringToReturn == "medium" && intToReturn <= self.medium) || (stringToReturn == "busy" && intToReturn <= self.busy)))
                            {
                                let x = PersonalisedTimes(date: day.day!, day: tempDay, time: tempTimeAsString, status: stringToReturn, tracker: intToReturn)
                                ThisWeek.Instance.personalisedTimesArray.append(x)
                            }
                        case 4:
                            if(ThisWeek.Instance.Four[index] == "free" && ((stringToReturn == "good" && intToReturn <= self.good) || (stringToReturn == "medium" && intToReturn <= self.medium) || (stringToReturn == "busy" && intToReturn <= self.busy)))
                            {
                                let x = PersonalisedTimes(date: day.day!, day: tempDay, time: tempTimeAsString, status: stringToReturn, tracker: intToReturn)
                                ThisWeek.Instance.personalisedTimesArray.append(x)
                            }
                        case 5:
                            if(ThisWeek.Instance.Five[index] == "free" && ((stringToReturn == "good" && intToReturn <= self.good) || (stringToReturn == "medium" && intToReturn <= self.medium) || (stringToReturn == "busy" && intToReturn <= self.busy)))
                            {
                                let x = PersonalisedTimes(date: day.day!, day: tempDay, time: tempTimeAsString, status: stringToReturn, tracker: intToReturn)
                                ThisWeek.Instance.personalisedTimesArray.append(x)
                            }
                        case 6:
                            if(ThisWeek.Instance.Six[index] == "free" && ((stringToReturn == "good" && intToReturn <= self.good) || (stringToReturn == "medium" && intToReturn <= self.medium) || (stringToReturn == "busy" && intToReturn <= self.busy)))
                            {
                                let x = PersonalisedTimes(date: day.day!, day: tempDay, time: tempTimeAsString, status: stringToReturn, tracker: intToReturn)
                                ThisWeek.Instance.personalisedTimesArray.append(x)
                            }
                        case 7:
                            if(ThisWeek.Instance.Seven[index] == "free" && ((stringToReturn == "good" && intToReturn <= self.good) || (stringToReturn == "medium" && intToReturn <= self.medium) || (stringToReturn == "busy" && intToReturn <= self.busy)))
                            {
                                let x = PersonalisedTimes(date: day.day!, day: tempDay, time: tempTimeAsString, status: stringToReturn, tracker: intToReturn)
                                ThisWeek.Instance.personalisedTimesArray.append(x)
                            }
                        default:
                            print(i)
                        }
                        
                    })
                })
                
            }
            start = NSDate()
            start = start.addingTimeInterval(TimeInterval(60*60*24*i))
        }
    
    }
    
    //this function retrieves the traffic data for the gym from the database
    func getStringFromDatabase(time: String, todaysDay: String, completion: @escaping(_ stringToReturn: String)->())
    {
        
        let ref = reference.ref
        ref.child(ThisWeek.Instance.monthType).child(todaysDay).child(time).observeSingleEvent(of: .value, with: { (snapshot) in
            let stringToReturn = snapshot.value as? String ?? ""
            completion(stringToReturn)
        })
    }
    //this function retrieves the tracking data from the database
    func numPeopleGoing(date: String, time: String, completion: @escaping(_ intToReturn: Int)->())
    {
        
        let ref = reference.ref
        
        ref.child("Tracking").child(date).child(time).observeSingleEvent(of: .value, with: { (snapshot) in
            let intToReturn = snapshot.value as? Int ?? 0
            completion(intToReturn)
        })
    }



}
