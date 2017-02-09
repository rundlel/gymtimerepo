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
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!

    
    override func viewDidAppear(_ animated: Bool) {
        welcomeUser()
        configureDatabase()

    }
    
    
    func welcomeUser()
    {
        guard let user = FIRAuth.auth()?.currentUser else {return}
        
        let displayName = user.email!.components(separatedBy: "@")[0]
        
        welcomeLabel.text = "Hello " + displayName
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
        })
    }
   }
