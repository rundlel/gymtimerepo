//
//  ThisWeek.swift
//  GymTime
//
//  Created by Laura Rundle on 23/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import Foundation


class ThisWeek {
    
    
    private static let _instance = ThisWeek()
    
    static var Instance: ThisWeek {
        return _instance
    }
    var personalisedTimesArray = [PersonalisedTimes]()
    
    
    var One = [String](repeating: "free", count: 15)
    
    var Two = [String](repeating: "free", count: 15)
    
    var Three = [String](repeating: "free", count: 15)
    
    var Four = [String](repeating: "free", count: 15)
    
    var Five = [String](repeating: "free", count: 15)
    
    var Six = [String](repeating: "free", count: 15)
    
    var Seven = [String](repeating: "free", count: 15)
    
    var DaysOfTheWeek: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var loadDatabase = true
    
    let AverageMonthArray = [11,12,3,4]
    let BusyMonthArray = [1,2,9,10]
    var monthType = "null"
    
    func getMonth()
    {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        for index in 0...3
        {
            if (BusyMonthArray[index] == month)
            {
                monthType = "BusyWeek"
            }
            else //summer months are to be classified as average
            {
                monthType = "AverageWeek"
            }
            
        }
        
    }
    
    var includeWeekend = true
    var includeToday = true


}
