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
    
    @IBAction func includeWeekendSwitch(_ sender: UISwitch) {
    }
    
    @IBAction func includeTodaySwitch(_ sender: UISwitch) {
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkAuthorisation()
        getEvents()
        fillInTimeTable()
        determineWhatTimesHaveAlreadyPassed()
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
        let today = NSDate()
        let unitFlags = Set<Calendar.Component>([.hour])
        var components =  NSCalendar.current.dateComponents(unitFlags, from: today as Date)
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
    
    
    func printTimeTables(array: [String])
    {
        for index in 0...14
        {
            print(array[index])
        }
        
        print("*******************")
    }


}
