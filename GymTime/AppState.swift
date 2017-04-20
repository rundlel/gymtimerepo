//
//  AppState.swift
//  GymTime
//
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import Foundation


class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
}
