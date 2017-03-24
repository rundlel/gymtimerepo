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
    
    //arrays representing each day of the week, one being today, two being tomorrow etc
    /*var One = [String](repeating: "free", count: 15)
    var Two = [String](repeating: "free", count: 15)
    var Three = [String](repeating: "free", count: 15)
    var Four = [String](repeating: "free", count: 15)
    var Five = [String](repeating: "free", count: 15)
    var Six = [String](repeating: "free", count: 15)
    var Seven = [String](repeating: "free", count: 15)
    var DaysOfTheWeek: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]*/
    
    let testEvent = EventDetails(startDate: NSDate() as Date, endDate: NSDate() as Date, duration: 0)
    var EventArray = [EventDetails]()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ThisWeek.Instance.getMonth()
        
        findBestTime { (true) in
            print("HEELO")
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
    
    
    func findBestTime(completion: @escaping (Bool) -> ())
    {
        var start = NSDate()
        let unitFlags = Set<Calendar.Component>([.weekday])
        var day =  NSCalendar.current.dateComponents(unitFlags, from: start as Date)
        let tempDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
        
        var dayCounter = 1
        
        print(tempDay)
        
        while(dayCounter <= 7)
        {
            //today = day 1
            print("daycounter")
            print(dayCounter)
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
                                self.personalisedTimesArray.append(x)
                            }
                            print("case 1")
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
                            self.personalisedTimesArray.append(x)
                        }
                        print("case 2")
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
                            self.personalisedTimesArray.append(x)
                        }
                        print("case 3")
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
                            self.personalisedTimesArray.append(x)
                        }
                        print("case 4")
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
                            self.personalisedTimesArray.append(x)
                        }
                        print("case 5")
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
                            self.personalisedTimesArray.append(x)
                        }
                        print("case 6")
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
                        
                        if(ThisWeek.Instance.Seven[index] == "free" && (stringToReturn == "good" || stringToReturn == "medium"))
                        {
                            let x = PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn)
                            self.personalisedTimesArray.append(x)
                        }
                        print("case 7")
                        print(self.personalisedTimesArray)
                    })
                }
            default:
                print(dayCounter)
            }
            
            print(tempDay)
            dayCounter = dayCounter + 1
            
    
        }
        completion(true)
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


