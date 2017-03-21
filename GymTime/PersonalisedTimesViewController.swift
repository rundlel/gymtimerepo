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
    
    var dateFormatter =  DateFormatter()
    
    //arrays representing each day of the week, one being today, two being tomorrow etc
    var One = [String](repeating: "free", count: 15)
    var Two = [String](repeating: "free", count: 15)
    var Three = [String](repeating: "free", count: 15)
    var Four = [String](repeating: "free", count: 15)
    var Five = [String](repeating: "free", count: 15)
    var Six = [String](repeating: "free", count: 15)
    var Seven = [String](repeating: "free", count: 15)
    
    let testEvent = EventDetails(startDate: NSDate() as Date, endDate: NSDate() as Date, duration: 0)
    var EventArray = [EventDetails]()
    
    override func viewDidAppear(_ animated: Bool)
    {
        checkAuthorisation()
        getEvents()
        printArray()
        fillInTimeTable()
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
    //find all events from now until one week's time
    //TODO alter to include all of 7th day? current is 7*24 from now. do 8 days and then just use the date in an if/else
    func getEvents()
    {
        let eventStore: EKEventStore = EKEventStore()
        
        let startDate = NSDate()
        let endDate = NSDate().addingTimeInterval(60*60*24*7)
        
        print(dateFormatter.string(from: startDate as Date))
        
        var duration = endDate.timeIntervalSince(startDate as Date)
        let predicate1 = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: nil)
        
        
        let eventVar = eventStore.events(matching: predicate1) as [EKEvent]!
        
        if eventVar != nil {
            for i in eventVar! {
                print("Title  \(i.title)" )
                print("startDate: \(i.startDate)" )
                print("endDate: \(i.endDate)" )
                
                duration = i.endDate.timeIntervalSince(i.startDate as Date)
                
                EventArray.append(EventDetails(startDate: i.startDate, endDate: i.endDate, duration: Int(duration)))
                print(dateFormatter.string(from: i.startDate))
            }
        }
    }
    func printArray()
    {
        print(EventArray)
    }
    
    func durationConversionToMinutes(second: Int) -> Int {
        let minutes = second / 60
        return minutes
    }
    //ASSUMPTION: user needs one hour to work out therefore any event is rounded up to the nearest hour
    func durationConversionToHours(minute: Int) -> Int {
        
        var hour = minute/60
        if(minute % 60 > 0)
        {
            hour = hour + 1
        }
        
        return hour
    }
    //uses the list of events to determine when the user is busy and when the user is free and stores the result in an array
    func fillInTimeTable()
    {
        let startDate = NSDate()
        let todaysDate = NSDate()
        let unitFlags = Set<Calendar.Component>([.hour, .day])
        var components =  NSCalendar.current.dateComponents(unitFlags, from: startDate as Date)
        var today = NSCalendar.current.dateComponents(unitFlags, from: todaysDate as Date)
        
        for i in 0..<EventArray.count
        {
            print(EventArray[i].startDate)
            components = NSCalendar.current.dateComponents(unitFlags, from: EventArray[i].startDate as Date)
            var hour = Int(components.hour!)
          //  let lastDay = NSDate().addingTimeInterval(60*60*24*7)
            
            let durationMinutes = durationConversionToMinutes(second: EventArray[i].duration)
            let durationHours = durationConversionToHours(minute: durationMinutes)
            
            let day = determineDay(date: components.day!, today: today.day!)
            
            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
            print(day)
           
            //if the event is during the Gym's opening hours
            //ASSUMPTION user needs an hour to work out and gym closes at 22:00 so only checks events up until 21:00
            if(hour >= 7 && hour <= 21)
            {
                switch(day) //CASE 0 represents today, CASE 1 represents tomorrow and so on
                {
                    case 0:
                        for _ in 1...durationHours
                        {
                            One[hour-7] = "busy"
                            hour = hour + 1
                        }
                    case 1:
                        for _ in 1...durationHours
                        {
                            Two[hour-7] = "busy"
                            hour = hour + 1
                        }
                    case 2:
                        for _ in 1...durationHours
                        {
                            Three[hour-7] = "busy"
                            hour = hour + 1
                        }
                    case 3:
                        for _ in 1...durationHours
                        {
                            Four[hour-7] = "busy"
                            hour = hour + 1
                        }
                    case 4:
                        for _ in 1...durationHours
                        {
                            Five[hour-7] = "busy"
                            hour = hour + 1
                        }
                    case 5:
                        for _ in 1...durationHours
                        {
                            Six[hour-7] = "busy"
                            hour = hour + 1
                        }
                    case 6:
                        for _ in 1...durationHours
                        {
                            Seven[hour-7] = "busy"
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
        
        printTimeTables(array: One)
        printTimeTables(array: Two)
        printTimeTables(array: Three)
        printTimeTables(array: Four)
        printTimeTables(array: Five)
        printTimeTables(array: Six)
        printTimeTables(array: Seven)
    }
    
    //this function determines the days of the upcoming week
    func determineDay(date: Int, today: Int) -> Int
    {
        let x = date - today
        return x
    }
    
    func printTimeTables(array: [String])
    {
        for index in 0...14
        {
            print(array[index])
        }
        
        print("*******************")
    }
  
}
    
    //TIMETABLE VISUALISATION
    //[  0   ][   1  ]
    //[7:00am][8:00am][9:00am][10:00am][11:00am][12:00pm][1:00pm][2:00pm][3:00pm][4:00pm][5:00pm][6:00pm][7:00pm][8:00pm][9:00pm]


 
 

