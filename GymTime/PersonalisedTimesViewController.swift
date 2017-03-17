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
        getEvents()
        
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
