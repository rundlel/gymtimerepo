    //
//  AppDelegate.swift
//  GymTime
//
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //configures the firebase services
        FIRApp.configure()
        
        // enables the keyboard library for every text library
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
}
