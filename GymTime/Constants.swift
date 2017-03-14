//
//  Constants.swift
//  GymTime
//
//  Created by Laura Rundle on 01/02/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let SignInToGT = "SignInToGT"
        static let FpToSignIn = "FPToSignIn"
        static let CalendarViewLoad = "CalendarViewLoad"
        static let CreateAccountView = "CreateAccountView"
        static let PersonalisedTimesView = "PersonalisedTimesView"
        static let BackToSignInView = "BackToLaunchScreen"
    }
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoURL = "photoURL"
        static let imageURL = "imageURL"
    }
}
