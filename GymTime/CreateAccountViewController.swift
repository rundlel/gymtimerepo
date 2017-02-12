//
//  CreateAccountViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 12/02/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit
import Firebase

@objc(CreateAccountViewController)
class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var createAccEmailField: UITextField!
    
    @IBOutlet weak var createAccPasswordField: UITextField!
    
    
    @IBAction func didTapcreateAccount(_ sender: AnyObject) {
        guard let email = createAccEmailField.text, let password = createAccPasswordField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error)
            in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.setDisplayName(user!)
        }
        
        
    }
    
    func setDisplayName(_ user: FIRUser?) {
        let changeRequest = user?.profileChangeRequest()
        changeRequest?.displayName = user?.email!.components(separatedBy: "@")[0]
        changeRequest?.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    func signedIn(_ user: FIRUser?) {
    MeasurementHelper.sendLoginEvent()
    
    AppState.sharedInstance.displayName = user?.displayName ?? user?.email
    AppState.sharedInstance.photoURL = user?.photoURL
    AppState.sharedInstance.signedIn = true
    let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
    performSegue(withIdentifier: Constants.Segues.SignInToGT, sender: nil)
    }


}
