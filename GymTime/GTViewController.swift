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
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBAction func personalisedTimes(_ sender: UIButton) {
        
        performSegue(withIdentifier: Constants.Segues.PersonalisedTimesView, sender: nil)

    }
    
    var monthType = "null"
    var switchButton = 0
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    let AverageMonthArray = [11,12,3,4]
    let BusyMonthArray = [1,2,9,10]

    @IBOutlet var displayLabel: UILabel!

    @IBOutlet var includeWeekends: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
     //   welcomeUser()
        configureDatabase()
        getMonth()
        displayInitialData()
    }
    
    
  //  func welcomeUser()
  //  {
   //     guard let user = FIRAuth.auth()?.currentUser else {return}
        
   //     let displayName = user.email!.components(separatedBy: "@")[0]
        
       //welcomeLabel.text = "Welcome to GymTime " + displayName
   // }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
        })
    }
    
    func getMonth()
    {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        for index in 0...3
        {
            if (AverageMonthArray[index] == month)
            {
                monthType = "average"
            }
            else if (BusyMonthArray[index] == month)
            {
                monthType = "busy"
            }
        }

    }
    func displayInitialData()
    {
        if (monthType == "busy")
        {
            displayLabel.text = "🗓✓ BEST DAYS: FRIDAY \n\n🗓✗ WORST DAYS: MONDAY & TUESDAY \n\n🕐✓BEST TIME: FRIDAY 7am - 12pm, 8am - 10am all week \n\n🕐✗WORST TIME: MONDAY 12pm-8pm, 4pm - 7pm all week"
        }
        else
        {
            displayLabel.text = "🗓✓ BEST DAYS: FRIDAY \n\n🗓✗ WORST DAYS: MONDAY & TUESDAY \n\n🕐✓BEST TIME: 8am - 11am all week \n\n🕐✗WORST TIME: 4pm - 7pm all week"
        }
    }
    
    @IBAction func weekendSwitch(_ sender: UISwitch) {
        
        
        if (sender.isOn == true)
        {
          switchButton = 1
            // includeWeekends.text = "yes, include weekends"
        }
        else
        {
            switchButton = 0
           // includeWeekends.text = "no, don't include weekends"
        }
        
            if (monthType == "busy")
        {
            if(switchButton == 0)
            {
               displayLabel.text = "🗓✓ BEST DAYS: FRIDAY \n\n🗓✗ WORST DAYS: MONDAY & TUESDAY \n\n🕐✓BEST TIME: FRIDAY 7am - 12pm, 8am - 10am all week \n\n🕐✗WORST TIME: MONDAY 12pm-8pm, 4pm - 7pm all week"
            }
            if(switchButton == 1)
            {
               displayLabel.text = "🗓✓ BEST DAYS: FRIDAY, SATURDAY, SUNDAY \n\n🗓✗ WORST DAYS: MONDAY & TUESDAY \n\n🕐✓BEST TIME: FRIDAY 7am - 12pm, 8am - 10am all week \n\n🕐✗WORST TIME: MONDAY 12pm-8pm, 4pm - 7pm all week"
            }
            
        }
        else //average or summer months
        {
            if(switchButton == 0)
            {
               displayLabel.text = "🗓✓ BEST DAYS: FRIDAY \n\n🗓✗ WORST DAYS: MONDAY & TUESDAY \n\n🕐✓BEST TIME: 8am - 11am all week \n\n🕐✗WORST TIME: 4pm - 7pm all week"
            }
            if(switchButton == 1)
            {
                displayLabel.text = "🗓✓ BEST DAYS: FRIDAY, SATURDAY, SUNDAY \n\n🗓✗ WORST DAYS: MONDAY & TUESDAY \n\n🕐✓BEST TIME: 8am - 11am all week \n\n🕐✗WORST TIME: 4pm - 7pm all week"
            }
            
        }

        
    }
    

}
