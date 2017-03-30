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
            //UIColor(red:0.20, green:0.49, blue:0.66, alpha:1.0)]
        
    }
}
