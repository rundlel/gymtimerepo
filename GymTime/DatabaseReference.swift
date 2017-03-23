//
//  DatabaseReference.swift
//  GymTime
//
//  Created by Laura Rundle on 22/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import Foundation
import Firebase

class DatabaseReference: NSObject{
    
    let ref = FIRDatabase.database().reference()
    var personalisedTimesArray = [PersonalisedTimes]()
    
}
