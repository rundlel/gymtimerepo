//
//  GTViewController.swift
//  GymTime
//
//  Copyright © 2017 Laura Rundle. All rights reserved.
//  This is the Controller for the 'Overview' Screen
//

import UIKit
import Firebase

@objc(GTViewController)
class GTViewController: UIViewController{
    
    
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet var displayLabel: UILabel!
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        configureDatabase()
        segmentSwitch.tintColor = UIColor(red:0.33, green:0.59, blue:0.91, alpha:1.0)
        
        //depending on the current date, the application will use the data corresponding to an 'AverageWeek'  or a 'BusyWeek'
        ThisWeek.Instance.getMonth()
        
        //When the 'Overview' screen loads the user is presented with the opening hours of the gym.
        displayInitialData()
    }

    //In the event that the user closes the app without signing out and adds a meeting/appointment to their calendar before opening the app again the users calendar needs to be reanalysed and re-compared with the gym data to provide accurate info.
    override func viewDidAppear(_ animated: Bool) {
     ThisWeek.Instance.loadDatabase = true
        
        
    }
    
  
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
      
    }
    
    @IBAction func logoutButton(_ sender: Any)
    {
        var user = FIRAuth.auth()?.currentUser
        try! FIRAuth.auth()!.signOut()
        user = FIRAuth.auth()?.currentUser

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //display appropriate data depending on which segment the user has selected
    @IBAction func displayData(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0)
        {
            displayLabel.text = "💪🏼MONDAY: 7am - 10.30pm \n\n🏃🏿TUESDAY: 7am - 10.30pm \n\n🏋🏾‍♀️WEDNESDAY: 7am - 10.30pm \n\n👟THURSDAY: 7am - 10.30pm \n\n🏃🏼‍♀️FRIDAY: 7am - 10pm \n\n🏋🏻SATURDAY: 9am - 6pm \n\n🎽SUNDAY: 9am - 6pm"
        }
        else
        {
            //the overview of busy times during the week will differ depending on whether it is an 'average' month or a 'busy' month
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
