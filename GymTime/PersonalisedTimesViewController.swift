//
//  PersonalisedTimesViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 17/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import Firebase

@objc(PersonalisedTimeViewController)
class PersonalisedTimeViewController: UIViewController {
    
    //let ref = FIRDatabase.database().reference()
   // var personalisedTimesArray = [PersonalisedTimes]()
    
  //  var reference = DatabaseReference()
    
    @IBAction func nextScreenButton(_ sender: UIButton) {
    }
    let reference = FIRDatabase.database().reference()
    var personalisedTimesArray = [PersonalisedTimes]()
    
    var includeToday = true
    var includeWeekend = true
    var Saturday = 0
    var Sunday = 0
    
    @IBOutlet weak var includeTodayLabel: UILabel!
    @IBOutlet weak var includeWeekendsLabel: UILabel!
    
    @IBAction func includeToday(_ sender: UISwitch)
    {
        if(sender.isOn)
        {
            includeToday = true
            print("include today")
        }
        else
        {
            includeToday = false
            print(" don't include today")
        }
    }
    
    @IBAction func includeWeekend(_ sender: UISwitch)
    {
        if(sender.isOn)
        {
            includeWeekend = true
            print("include weekend")
        }
        else
        {
            includeWeekend = false
            print(" don't include weekend")
        }
    }

    var dateFormatter =  DateFormatter()
    var EventArray = [EventDetails]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ThisWeek.Instance.getMonth()
        
        findBestTime()
        let delay = 3.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay)
        {
            print(self.personalisedTimesArray)
        }
        
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
        var tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
        
        var dayCounter = 1
        while(dayCounter <= 7)
        {
            switch(dayCounter)
            {
                case 1:
                    start = NSDate()
                    day =  NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                    tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                    for index in 0...ThisWeek.Instance.One.count - 1
                    {
                        let tempTime = index + 7
                        let tempTimeAsString = String(tempTime)
                    
                        getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                            print(stringToReturn)
                        
                            if(ThisWeek.Instance.One[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                            {
                                let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                                self.personalisedTimesArray.append(x)
                            }
                        })
                    }
            case 2:
                start = start.addingTimeInterval(60*60*24)
                day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Two.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Two[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            self.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 3:
                start = start.addingTimeInterval(60*60*24*2)
                day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Three.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Three[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            self.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 4:
                start = start.addingTimeInterval(60*60*24*3)
                day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Four.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Four[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            self.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 5:
                start = start.addingTimeInterval(60*60*24*4)
                day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Five.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Five[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            self.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 6:
                start = start.addingTimeInterval(60*60*24*5)
                day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Six.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Six[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            self.personalisedTimesArray.append(x)
                        }
                    })
                }
            case 7:
                start = start.addingTimeInterval(60*60*24*6)
                day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
                tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
                
                for index in 0...ThisWeek.Instance.Seven.count - 1
                {
                    let tempTime = index + 7
                    let tempTimeAsString = String(tempTime)
                    getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                        
                        if(ThisWeek.Instance.Seven[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium" || stringToReturn == "busy"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            self.personalisedTimesArray.append(x)
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
    
    //TIMETABLE VISUALISATION
    //[  0   ][   1  ]
    //[7:00am][8:00am][9:00am][10:00am][11:00am][12:00pm][1:00pm][2:00pm][3:00pm][4:00pm][5:00pm][6:00pm][7:00pm][8:00pm][9:00pm]


    }


