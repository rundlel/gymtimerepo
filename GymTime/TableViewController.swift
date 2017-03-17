//
//  TableViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 09/02/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit
import Firebase
import EventKit
//UITableViewDataSource

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    //connect to event store
    //get appropriate calendar
    //create start date component
    //create end date component
    //create predicate
    //fetch events that match predicate
 
    
       /*
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?

    var c: EKCalendar!
    var events: [EKEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCalendarAuthorizationStatus()
        loadEvents()
    }

    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            //needPermissionView.fadeIn()
            print("PERMISSION VIEW")
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                self.fetchEventsFromCalendar(calendarTitle: "Home")
                print("POINT 1 ACCESS GRANTED")
            }
        } as! EKEventStoreRequestAccessCompletionHandler)
    }
    
    func fetchEventsFromCalendar(calendarTitle: String) -> Void {
        
        for calendar:EKCalendar in calendars! {
            
            if calendar.title == calendarTitle {
                let selectedCalendar = calendar
                
                let startDate = NSDate()
                let endDate = NSDate(timeIntervalSinceNow: 60*60*24*30)
                let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [selectedCalendar])
                let events = eventStore.events(matching: predicate) as [EKEvent]
                print("POINT 2  PRINT EVENTS")
                print("Events: \(events)")
                for event in events {
                    print("Event Title : \(event.title) Event ID: \(event.eventIdentifier)")
                }
                
            }
        }
    }
    
    func loadCalendars() {
        self.calendars = EKEventStore().calendars(for: EKEntityType.event).sorted() { (cal1, cal2) -> Bool in
            return cal1.title < cal2.title
        }
    }
    
    func refreshTableView() {
        tableView.isHidden = false
        tableView.reloadData()
}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendars = self.calendars {
            return calendars.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        
        if let calendars = self.calendars {
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell.textLabel?.text = calendarName
        } else {
            cell.textLabel?.text = "Unknown Calendar Name"
        }
        
        return cell
}
    func loadEvents()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    
        let startDate = dateFormatter.date(from: "2016-01-01")
        let endDate = dateFormatter.date(from: "2016-12-31")
    
        if let startDate = startDate, let endDate = endDate
        {
            let eventStore = EKEventStore()
            
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [c])
    
            self.events = eventStore.events(matching: eventsPredicate).sorted
                {
                    (e1: EKEvent, e2: EKEvent) in
    
                    return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
                }
        }
    }


  /* // let dataSourceArray = ["hello", "world", "laura"]
 
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]!
   // var events: [EKEvent]?

    
    
    @IBOutlet weak var calendarsTableView: UITableView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        checkCalendarAuthorizationStatus()
    }
    
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            //needPermissionView.fadeIn()
            print("permission view fade")
        }
    }
    func requestAccessToCalendar() {
        EKEventStore().requestAccess(to: .event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                    self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //self.needPermissionView.fadeIn()
                    print("permission 2")
                })
            }
        })
    }
    
    
    func loadCalendars() {
        self.calendars = EKEventStore().calendars(for: EKEntityType.event).sorted() { (cal1, cal2) -> Bool in
            return cal1.title < cal2.title
        }
    }
    func refreshTableView() {
        calendarsTableView.isHidden = false
        calendarsTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return dataSourceArray.count // Most of the time my data source is an array of something...  will replace with the actual name of the data source
        if let calendars = self.calendars {
            return calendars.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")!
        
        if let calendars = self.calendars {
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell.textLabel?.text = calendarName
        } else {
            cell.textLabel?.text = "Unknown Calendar Name"
        }
        
        return cell
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
       // let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        
       // cell.textLabel?.text = dataSourceArray[indexPath.row]
        
        
    
        // set cell's detailTextLabel.text property
      //  return cell
    }
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }*/ */
}
