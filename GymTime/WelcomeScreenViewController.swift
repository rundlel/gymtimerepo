//
//  WelcomeScreenViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 31/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit
import Firebase
import EventKit

class WelcomeScreenViewController: UIViewController {

    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var informationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.informationLabel.text = "Gym Time tells you the best times for you to work out in Trinity Gym this week. \n\n\n\nAll you need to do is make sure you have all your lectures, meetings and coffee breaks scehduled in your Calendar and we'll look after the rest!"
        checkAuthorisation()
        let delay = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay)
        {
            self.createPreferences()
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createPreferences()
    {
        let user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        ref.child("Preferences").child((user?.uid)!).setValue(["today" : true, "weekend" : true])
    }
    
    @IBAction func didTapOkay(_ sender: Any) {
        
        performSegue(withIdentifier: Constants.Segues.FpToSignIn, sender: nil)
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
                        print("access granted")
                })
            }
            else
            {
                DispatchQueue.main.async(execute:
                {
                    print("access denied")
                })
            }
        })
    }
    
   
}
