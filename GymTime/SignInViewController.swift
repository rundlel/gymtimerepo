//
//  SignInViewController.swift
//  GymTime
//
//  Copyright © 2017 Laura Rundle. All rights reserved.
//  The author utilised the sample Firebase FriendlyChat project to implement this functionality.
//

import UIKit

import Firebase
import CoreGraphics

@objc(SignInViewController)
class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var signInButton: UIButton!
   
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    //if user is already signed in, progress to 'Overview' screen
    override func viewDidAppear(_ animated: Bool)
    {
        let user = FIRAuth.auth()?.currentUser
        if user != nil
        {
            performSegue(withIdentifier: Constants.Segues.SignInToGT, sender: nil)
        }

    }
    //if the user taps outside of the text field, hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    @IBOutlet var signInErrorMessage: UILabel!
    
    //Pass email and password to Firebase for verification
    @IBAction func didTapSignIn(_ sender: AnyObject)
    {
        guard let email = emailField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.signInErrorMessage.text = "Invalid username or password"
                    return
            }
            self.signedIn(user!)
        }
        
    }
    
    
    @IBAction func didTapSignUp(_ sender: AnyObject)
    {
        performSegue(withIdentifier: Constants.Segues.CreateAccountView, sender: nil)
    }

    @IBAction func didTapPasswordReset(_ sender: Any)
    {
        //present user with prompt for their email
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
        
        //when they select okay, if email has been entered firebase will send the reset password email, if nothing has been entered the alert will be dismissed.
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil);

    }
    
    func signedIn(_ user: FIRUser?)
    {
        MeasurementHelper.sendLoginEvent()
        performSegue(withIdentifier: Constants.Segues.SignInToGT, sender: nil)
    }
    
    









}
