//
//  GTViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 05/02/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit
import Firebase

@objc(GTViewController)
class GTViewController: UIViewController{
    
    
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []

    fileprivate var _refHandle: FIRDatabaseHandle!
    
    @IBOutlet var displayLabel: UILabel!
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        configureDatabase()
        segmentSwitch.tintColor = UIColor(red:0.33, green:0.59, blue:0.91, alpha:1.0)
        ThisWeek.Instance.getMonth()
        displayInitialData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
     
        
        
    }
    
  
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
      
    }
    
    
    @IBAction func displayData(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0)
        {
            displayLabel.text = "💪🏼MONDAY: 7am - 10.30pm \n\n🏃🏿TUESDAY: 7am - 10.30pm \n\n🏋🏾‍♀️WEDNESDAY: 7am - 10.30pm \n\n👟THURSDAY: 7am - 10.30pm \n\n🏃🏼‍♀️FRIDAY: 7am - 10pm \n\n🏋🏻SATURDAY: 9am - 6pm \n\n🎽SUNDAY: 9am - 6pm"
        }
        else
        {
            if (ThisWeek.Instance.monthType == "busy")
            {
                displayLabel.text = "🗓✓ BEST DAYS: FRIDAY, SATURDAY, SUNDAY \n\n🗓✗ WORST DAYS: MONDAY & TUESDAY \n\n🕐✓BEST TIME: FRIDAY 7am - 12pm, 8am - 10am all week \n\n🕐✗WORST TIME: MONDAY 12pm-8pm, 4pm - 7pm all week"
            }
            else
            {
                displayLabel.text = "🗓✓ BEST DAYS: FRIDAY, SATURDAY, SUNDAY \n\n🗓✗ WORST DAYS: MONDAY & TUESDAY \n\n🕐✓BEST TIME: 8am - 11am all week \n\n🕐✗WORST TIME: 4pm - 7pm all week"
            }
        }
    }
    
    
    
    
    func displayInitialData()
    {
        displayLabel.text = "💪🏼MONDAY: 7am - 10.30pm \n\n🏃🏿TUESDAY: 7am - 10.30pm \n\n🏋🏾‍♀️WEDNESDAY: 7am - 10.30pm \n\n👟THURSDAY: 7am - 10.30pm \n\n🏃🏼‍♀️FRIDAY: 7am - 10pm \n\n🏋🏻SATURDAY: 9am - 6pm \n\n🎽SUNDAY: 9am - 6pm"
    }
    


}
