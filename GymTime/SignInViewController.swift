//
//  SignInViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 01/02/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
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
      //  signInButton.layer.borderWidth = 1.0
        //let borderColour = (UIColor(red: 0.22, green: 0.47, blue: 0.60, alpha: 1.0))
        
      //  let color : CGColor! = (red: CGFloat(0.22), green: CGFloat(0.47), blue: CGFloat(0.60), alpha: CGFloat(1.0))
        
       // signInButton?.layer.borderColor = UIColor(red: 0.22, green: 0.47, blue: 0.60, alpha: 1.0).cgColor
      //  print("Here")
            
            //CGColor.init(red: CGFloat(0.22), green: CGFloat(0.47), blue: CGFloat(0.60), alpha: CGFloat(1.0))
        
      //  init(red: CGFloat(0.22), green: CGFloat(0.47), blue: CGFloat(0.60), alpha: CGFloat(1.0))
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let user = FIRAuth.auth()?.currentUser
        if user != nil
        {
            performSegue(withIdentifier: Constants.Segues.SignInToGT, sender: nil)
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    @IBOutlet var signInErrorMessage: UILabel!
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
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
    
    
    @IBAction func didTapSignUp(_ sender: AnyObject) {
    performSegue(withIdentifier: Constants.Segues.CreateAccountView, sender: nil)
    
    
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


    @IBAction func didTapPasswordReset(_ sender: Any) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
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
