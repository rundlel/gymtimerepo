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

    
    override func viewDidAppear(_ animated: Bool) {
     //   welcomeUser()
        configureDatabase()
        ThisWeek.Instance.getMonth()
        displayInitialData()
    }
    
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
      
    }
    
    
    func displayInitialData()
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
