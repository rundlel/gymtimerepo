//
//  AppState.swift
//  GymTime
//
//  Created by Laura Rundle on 01/02/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import Foundation


class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
}
