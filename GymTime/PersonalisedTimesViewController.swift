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
    
    override func viewDidAppear(_ animated: Bool) {
       checkAuthorisation()
      //  getEvents()
        getEventByTime()
        
    }
    var dateFormatter =  DateFormatter()
    
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
        

        let predicate1 = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: nil)
        
        print("startDate:\(startDate) endDate:\(endDate)")
        
        let eventVar = eventStore.events(matching: predicate1) as [EKEvent]!
        
        if eventVar != nil {
            for i in eventVar! {
                print("Title  \(i.title)" )
                print("startDate: \(i.startDate)" )
                print("endDate: \(i.endDate)" )
                
                
                print(dateFormatter.string(from: i.startDate))
                
                
                if i.title == "Test Title" {
                    print("YES" )
                    // Uncomment if you want to delete
                    //eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                }
            }
        }
    }
    
    func getEventByTime()
    {
        
        let eventStore2: EKEventStore = EKEventStore()
        var startDate = NSDate()
        let endDate = NSDate().addingTimeInterval(60*60*24)
        var y = endDate.timeIntervalSince(startDate as Date)
        
        var x = endDate.timeIntervalSince(startDate as Date)
        if(x<0)
        {
            print("yes")
        }
        
        
        var whileBool = true
        
      
        while (whileBool == true)
        {
            
            let predicate = eventStore2.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: nil)
            let eventVar = eventStore2.events(matching: predicate) as [EKEvent]!
            
            if eventVar != nil
            {
               for i in eventVar! {
                    print("Title  \(i.title)" )
                    print("startDate: \(i.startDate)" )
                    print("endDate: \(i.endDate)" )
                    //duration of the event
                    y = i.endDate.timeIntervalSince(i.startDate as Date)
                    print(y)
                
                }
                
            }
            
            startDate = startDate.addingTimeInterval(60*60*1*1)
            
            
          //  print("startDate:\(startDate) endDate:\(endDate)")
            
            x = endDate.timeIntervalSince(startDate as Date)
        
            if(x<0)
            {
                whileBool = false
            }
            
           /* if(startDate.isEqual(to: endDate as Date))
            {
                print("FALSE")
                whileBool = false
            }
            else
            {
                print("TRUE")
            }*/
        

        }
        
    }
    
    
}
