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
        getEvents()
        
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
       present(alert, animated: true, completion: nil)
        
    
    }

    func getEvents()
    {
        let eventStore: EKEventStore = EKEventStore()
        
        let startDate = NSDate().addingTimeInterval(-60*60*24)
        let endDate = NSDate().addingTimeInterval(60*60*24*3)
        
        let predicate1 = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: nil)
        
        print("startDate:\(startDate) endDate:\(endDate)")
        
        let eventVar = eventStore.events(matching: predicate1) as [EKEvent]!
        
        if eventVar != nil {
            for i in eventVar! {
                print("Title  \(i.title)" )
                print("startDate: \(i.startDate)" )
                print("endDate: \(i.endDate)" )
                
                if i.title == "Test Title" {
                    print("YES" )
                    // Uncomment if you want to delete
                    //eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                }
            }
        }
    }
    
}
