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

class PersonalisedTimeViewController: UIViewController {
    
    var dateFormatter =  DateFormatter()
    
    var One = [String](repeating: "free", count: 15)
    var Two = [String](repeating: "free", count: 15)
    var Three = [String](repeating: "free", count: 15)
    var Four = [String](repeating: "free", count: 15)
    var Five = [String](repeating: "free", count: 15)
    var Six = [String](repeating: "free", count: 15)
    var Seven = [String](repeating: "free", count: 15)
    
    
    let oneHourInSeconds = 3600
    
    
    struct EventDetails
    {
        var startDate = NSDate() as Date
        var endDate = NSDate() as Date
        var duration = 0
    }
    let testEvent = EventDetails(startDate: NSDate() as Date, endDate: NSDate() as Date, duration: 0)
    
    var EventArray = [EventDetails]()
    
    

    
    
    override func viewDidAppear(_ animated: Bool)
    {
        checkAuthorisation()
        getEvents()
        printArray()
        //getEventByTime()
        fillInTimeTable()
        
    }
    
    
    
    func checkAuthorisation()
    {
            let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
            
            switch (status) {
            case EKAuthorizationStatus.notDetermined:
                // This happens on first-run
                print ("not Determined")
                requestAccessToCalendar()
            case EKAuthorizationStatus.authorized:
                // Things are in line with being able to show the calendars in the table view
               print("authorised")
            case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
                // We need to help them give us permission
                print("restricted")
                alertTheUser()
            }
    }



    func requestAccessToCalendar() {
        EKEventStore().requestAccess(to: .event, completion: {
            (accessGranted: Bool, error: Error?) in
        
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                //    self.loadCalendars()
                 //   self.refreshTableView()
                    print("request Access")
                    
            })
            } else {
                DispatchQueue.main.async(execute: {
                   // self.needPermissionView.fadeIn()
                    self.alertTheUser()
                })
            }
        })
}


    func alertTheUser(){
        /*let alert = UIAlertController(title: "We Need Permission", message: "GymTime needs access to your calendar in order to tell you the best time for you", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Go To Settings", style: UIAlertActionStyle.destructive, handler: { action in
            
            let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(openSettingsUrl!)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alert.show()*/
        
        let alert = UIAlertController(title: "GymTime needs permission",
                                      message: "GymTime needs access to your calendar in order to tell you the best time for you",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go To Settings", style: .default, handler: { action in
            let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(openSettingsUrl!)

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
       present(alert, animated: true, completion: nil)
        
    
    }

    func getEvents()
    {
        let eventStore: EKEventStore = EKEventStore()
        
        let startDate = NSDate()
        let endDate = NSDate().addingTimeInterval(60*60*24*7)
        print(dateFormatter.string(from: startDate as Date))
        
        var duration = endDate.timeIntervalSince(startDate as Date)
        

        let predicate1 = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: nil)
        
        print("startDate:\(startDate) endDate:\(endDate)")
        
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
    
    func durationConversionToHours(minute: Int) -> Int {
        
        var hour = minute/60
        if(minute % 60 > 0)
        {
            hour = hour + 1
        }
        
        return hour
    }
    
    func fillInTimeTable()
    {
        let startDate = NSDate()
        let todaysDate = NSDate()
        let unitFlags = Set<Calendar.Component>([.hour, .day])
        var components =  NSCalendar.current.dateComponents(unitFlags, from: startDate as Date)
        var today = NSCalendar.current.dateComponents(unitFlags, from: todaysDate as Date)
        
        print(components.day!)
        
        for i in 0..<EventArray.count
        {
            print(EventArray[i].startDate)
            components = NSCalendar.current.dateComponents(unitFlags, from: EventArray[i].startDate as Date)
            var hour = Int(components.hour!)
            
            
            let durationMinutes = durationConversionToMinutes(second: EventArray[i].duration)
            let durationHours = durationConversionToHours(minute: durationMinutes)
            
            let x = determineDay(date: components.day!, today: today.day!)
           
            if(hour >= 7 && hour <= 21)
            {
                switch(x)
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
                    
                    
                    
                    default:
                    print("ERROR ERROR ERROR")
                    print(hour-7)
                    print(x)
                    
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
    
    func determineDay(date: Int, today: Int) -> Int {
        
        
        let x = date - today
        return x
    }
    
    func determineBusyHours(array: [String], duration: Int, hour: Int) -> [String]
    {
        var tempHour = hour
        
        for _ in 1...duration
        {
      //      array[tempHour-7] = "busy"
            tempHour = tempHour + 1
        }
        return array
        
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
    /*
 switch(components.hour!){
 case 7:
 Monday[0] = "busy"
 case 8:
 Monday[1] = "busy"
 case 9:
 Monday[2] = "busy"
 case 10:
 Monday[3] = "busy"
 case 11:
 Monday[4] = "busy"
 case 12:
 Monday[5] = "busy"
 case 13:
 Monday[6] = "busy"
 case 14:
 Monday[7] = "busy"
 case 15:
 Monday[8] = "busy"
 case 16:
 Monday[9] = "busy"
 case 17:
 Monday[10] = "busy"
 case 18:
 Monday[11] = "busy"
 case 19:
 Monday[12] = "busy"
 case 20:
 Monday[13] = "busy"
 case 21:
 Monday[14] = "busy"
 default:
 print(components)
 break*/
 
 

