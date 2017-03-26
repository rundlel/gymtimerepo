//
//  PreferencesViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 23/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//
import UIKit
import Foundation
import EventKit
import Firebase


class PreferencesViewController: UIViewController{
    
    var dateFormatter =  DateFormatter()
    
    var EventArray = [EventDetails]()
    
    @IBOutlet weak var mustGivePermissionLabel: UILabel!
    
    let reference = FIRDatabase.database().reference()
  //  var personalisedTimesArray = [PersonalisedTimes]()
    
    var globalvariabletoday = NSDate()
    let globalvariableunitFlags = Set<Calendar.Component>([.hour, .day])
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PersonalisedTimesView"
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PersonalisedTimesView")
            self.present(vc, animated: true, completion: nil)

        }
    }*/
   
    @IBAction func didTapContinue(_ sender: UIButton) {
        
        let delay = 3.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay)
        {
            
        
            let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
            if (status != EKAuthorizationStatus.authorized)
            {
                self.mustGivePermissionLabel.text = "GymTime needs access to your calendar in order to show you your preferences. Go to Settings -> GymTime and enable the Calendar switch."
            
            
            }
            else
            {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TableViewController")
                self.present(vc, animated: true, completion: nil)

            //performSegue(withIdentifier: Constants.Segues.PersonalisedTimesView)
            
            }
        }
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        checkAuthorisation()
        getEvents()
        fillInTimeTable()
        determineWhatTimesHaveAlreadyPassed()
        ThisWeek.Instance.getMonth()
        
        findBestTime()
        let delay = 3.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay)
        {
            print(ThisWeek.Instance.personalisedTimesArray)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
     //   checkAuthorisation()
     //   getEvents()
    //    fillInTimeTable()
     //   determineWhatTimesHaveAlreadyPassed()
    }
    
    
    func checkAuthorisation()
    {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            print ("not Determined")
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            print("authorised")
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            print("restricted")
            alertTheUser()
        }
    }
    
    func requestAccessToCalendar()
    {
        EKEventStore().requestAccess(to: .event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true
            {
                DispatchQueue.main.async(execute:
                    {
                        print("request Access")
                })
            }
            else
            {
                DispatchQueue.main.async(execute:
                    {
                        self.alertTheUser()
                })
            }
        })
    }
    
    func alertTheUser()
    {
        let alert = UIAlertController(title: "GymTime needs permission",
                                      message: "GymTime needs access to your calendar in order to tell you the best time for you",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go To Settings", style: .default, handler: { action in
            let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(openSettingsUrl!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        //TO DO use a label to notify the user that in order to use the best times feature access to calendar must be turned on
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func getEvents()
    {
        let eventStore: EKEventStore = EKEventStore()
        
       // let startDate = NSDate()
        let endDate = NSDate().addingTimeInterval(60*60*24*7)
        
        print(dateFormatter.string(from: globalvariabletoday as Date))
        
        let predicate1 = eventStore.predicateForEvents(withStart: globalvariabletoday as Date, end: endDate as Date, calendars: nil)
        
        let eventVar = eventStore.events(matching: predicate1) as [EKEvent]!
        
        if eventVar != nil {
            for i in eventVar! {
                print("Title  \(i.title)" )
                print("startDate: \(i.startDate)" )
                print("endDate: \(i.endDate)" )
                
                let duration = i.endDate.timeIntervalSince(i.startDate as Date)
                
                EventArray.append(EventDetails(startDate: i.startDate, endDate: i.endDate, duration: Int(duration)))
            }
        }
    }
    
    func durationConversionToMinutes(second: Int) -> Int {
        let minutes = second / 60
        return minutes
    }
    
    func durationConversionToHours(minute: Int) -> Int {
        
        var hour = minute/60
        if(minute % 60 > 0)
        {
            hour = hour + 1
        }
        
        return hour
    }
    
    func determineDay(date: Int, today: Int) -> Int
    {
        let x = date - today
        return x
    }
    
    func fillInTimeTable()
    {
        
       
        var components = NSCalendar.current.dateComponents(globalvariableunitFlags, from: globalvariabletoday as Date)
        let todayComponent = NSCalendar.current.dateComponents(globalvariableunitFlags, from: globalvariabletoday as Date)
       
        
        for i in 0..<EventArray.count
        {
            print(EventArray[i].startDate)
            components = NSCalendar.current.dateComponents(globalvariableunitFlags, from: EventArray[i].startDate as Date)
            var hour = Int(components.hour!)
            
            let durationMinutes = durationConversionToMinutes(second: EventArray[i].duration)
            let durationHours = durationConversionToHours(minute: durationMinutes)
            
            let day = determineDay(date: components.day!, today: todayComponent.day!)
            
            //if the event is during the Gym's opening hours
            //ASSUMPTION user needs an hour to work out and gym closes at 22:00 so only checks events up until 21:00
            
            if(hour >= 7 && hour <= 21)
            {
                switch(day) //CASE 0 represents today, CASE 1 represents tomorrow and so on
                {
                case 0:
                    for _ in 1...durationHours
                    {
                        ThisWeek.Instance.One[hour-7] = "busy"
                        hour = hour + 1
                    }
                case 1:
                    for _ in 1...durationHours
                    {
                        ThisWeek.Instance.Two[hour-7] = "busy"
                        hour = hour + 1
                    }
                case 2:
                    for _ in 1...durationHours
                    {
                        ThisWeek.Instance.Three[hour-7] = "busy"
                        hour = hour + 1
                    }
                case 3:
                    for _ in 1...durationHours
                    {
                        ThisWeek.Instance.Four[hour-7] = "busy"
                        hour = hour + 1
                    }
                case 4:
                    for _ in 1...durationHours
                    {
                        ThisWeek.Instance.Five[hour-7] = "busy"
                        hour = hour + 1
                    }
                case 5:
                    for _ in 1...durationHours
                    {
                        ThisWeek.Instance.Six[hour-7] = "busy"
                        hour = hour + 1
                    }
                case 6:
                    for _ in 1...durationHours
                    {
                        ThisWeek.Instance.Seven[hour-7] = "busy"
                        hour = hour + 1
                    }
                case 7:
                    print(day)
                default:
                    print("ERROR ERROR ERROR")
                    print(hour-7)
                    print(day)
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
    
    func determineWhatTimesHaveAlreadyPassed()
    {
        
        var components =  NSCalendar.current.dateComponents(globalvariableunitFlags, from: globalvariabletoday as Date)
        
        let hour = Int(components.hour!)
        print(hour)
        
        if(hour > 7 && hour < 21)
        {
            for i in 7...hour
            {
                ThisWeek.Instance.One[i-7] = "not available"
            }
        }
        printTimeTables(array: ThisWeek.Instance.One)
    }
    
    func whenIsTheWeekend()
    {
        
        var day = NSDate()
        var todayDate =  NSCalendar.current.dateComponents(globalvariableunitFlags, from: globalvariabletoday as Date)
        var weekendBool = true
        
        while(weekendBool)
        {
            let weekend = NSCalendar.current.isDateInWeekend(day as Date)
            var dayDate =  NSCalendar.current.dateComponents(globalvariableunitFlags, from: day as Date)
            
            if(weekend == true)
            {
                let x = determineDay(date: dayDate.day!, today: todayDate.day!)
                ThisWeek.Instance.Saturday = x
                ThisWeek.Instance.Sunday = x + 1
                weekendBool = false
            }
            else
            {
                day = day.addingTimeInterval(60*60*24)
            }
        }
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
    
    func findBestTime()
    {
        var start = NSDate()
        let unitFlags = Set<Calendar.Component>([.weekday])
        var day =  NSCalendar.current.dateComponents(unitFlags, from: start as Date)
        let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
        
        var dayCounter = 1
        while(dayCounter <= 7)
        {
            switch(dayCounter)
            {
            case 1:
                let start = NSDate()
                let day =  NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.One.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        print(stringToReturn)
                        
                        if(ThisWeek.Instance.One[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            ThisWeek.Instance.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 2:
                let start = start.addingTimeInterval(60*60*24)
                let day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Two.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Two[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            ThisWeek.Instance.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 3:
                let start = start.addingTimeInterval(60*60*24*2)
                let day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Three.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Three[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            ThisWeek.Instance.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 4:
                let start = start.addingTimeInterval(60*60*24*3)
                let day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Four.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Four[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                           ThisWeek.Instance.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 5:
                let start = start.addingTimeInterval(60*60*24*4)
                let day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Five.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Five[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            ThisWeek.Instance.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 6:
                let start = start.addingTimeInterval(60*60*24*5)
                let day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Six.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Six[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            ThisWeek.Instance.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 7:
                let start = start.addingTimeInterval(60*60*24*6)
                let day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Seven.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Seven[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium" || stringToReturn == "busy"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            ThisWeek.Instance.personalisedTimesArray.append(x)
                        }
                    })
                }
            default:
                print(dayCounter)
            }
            dayCounter = dayCounter + 1
        }
    }
    
    func getStringFromDatabase(time: String, todaysDay: String, completion: @escaping(_ stringToReturn: String)->())
    {
        
        let ref = reference.ref
        ref.child(ThisWeek.Instance.monthType).child(todaysDay).child(time).observeSingleEvent(of: .value, with: { (snapshot) in
            let stringToReturn = snapshot.value as? String ?? ""
            completion(stringToReturn)
        })
    }



}