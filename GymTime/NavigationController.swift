//
//  NavigationController.swift
//  GymTime
//
//  Copyright © 2017 Laura Rundle. All rights reserved.
//  The NavigationController provides the back button

import Foundation
import UIKit

class NavigationController: UINavigationController
{
    override func viewDidLoad() {
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red:0.33, green:0.59, blue:0.91, alpha:1.0)]
    }
}
