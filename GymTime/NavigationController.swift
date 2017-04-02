//
//  NavigationController.swift
//  GymTime
//
//  Created by Laura Rundle on 30/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController
{
    override func viewDidLoad() {
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red:0.33, green:0.59, blue:0.91, alpha:1.0)]
    }
}
