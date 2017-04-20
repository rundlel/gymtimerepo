//
//  CreateAccountViewController.swift
//  GymTime
//
//  Copyright © 2017 Laura Rundle. All rights reserved.
//  The author utilised the Firebase FriendlyChat project to implement some of the below functionality
//

import UIKit
import Firebase

@objc(CreateAccountViewController)
class CreateAccountViewController: UIViewController {
    
   
    
    @IBOutlet weak var createAccEmailField: UITextField!
    
    @IBOutlet weak var createAccPasswordField: UITextField!
    
    @IBOutlet var errorMessage: UILabel!
    
    // When the user enters their email and password, Firebase creates a User object, if there is an error with the creation of this object an appropriate error message is displayed to the user
    
    @IBAction func didTapcreateAccount(_ sender: AnyObject) {
        guard let email = createAccEmailField.text, let password = createAccPasswordField.text else { return }
    
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error)
            in
            if let error = error {
                print(error.localizedDescription)
                if (error.localizedDescription.range(of:"badly formatted") != nil)
                {
                    self.errorMessage.text = "Please enter a valid email address"
                }
                else if (error.localizedDescription.range(of: "6") != nil)
                {
                    self.errorMessage.text = "Your password must be at least 6 characters long"
                }
                else if (error.localizedDescription.range(of: "already in use") != nil)
                {
                    self.errorMessage.text = "This email address is already in use by another account"
                }
                
                return
            }
           
        }
    }
    
    //if the user taps outside of the text field, hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    @IBAction func backToSignIn(_ sender: UIButton)
    {
       performSegue(withIdentifier: Constants.Segues.BackToSignInView, sender: nil) 
    }
    
    
    
    func signedIn(_ user: FIRUser?)
    {
        MeasurementHelper.sendLoginEvent()
        performSegue(withIdentifier: Constants.Segues.goToWelcomeScreen, sender: nil)
        
    }
    
    
}
