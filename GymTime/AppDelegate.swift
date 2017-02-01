//
//  AppDelegate.swift
//  GymTime
//
//  Created by Laura Rundle on 29/01/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        return true
    }
    
}
