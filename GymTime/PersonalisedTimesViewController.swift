//
//  PersonalisedTimesViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 17/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import Firebase

@objc(PersonalisedTimeViewController)
class PersonalisedTimeViewController: UIViewController {
    
    //let ref = FIRDatabase.database().reference()
   // var personalisedTimesArray = [PersonalisedTimes]()
    
    var reference = DatabaseReference()
    
    var includeToday = true
    var includeWeekend = true
    var Saturday = 0
    var Sunday = 0
    
    @IBOutlet weak var includeTodayLabel: UILabel!
    @IBOutlet weak var includeWeekendsLabel: UILabel!
    
    @IBAction func includeToday(_ sender: UISwitch)
    {
        if(sender.isOn)
        {
            includeToday = true
            print("include today")
        }
        else
        {
            includeToday = false
            print(" don't include today")
        }
    }
    
    @IBAction func includeWeekend(_ sender: UISwitch)
    {
        if(sender.isOn)
        {
            includeWeekend = true
            print("include weekend")
        }
        else
        {
            includeWeekend = false
            print(" don't include weekend")
        }
        
    }
    
    let AverageMonthArray = [11,12,3,4]
    let BusyMonthArray = [1,2,9,10]
    var monthType = "null"
    

    
    var dateFormatter =  DateFormatter()
    
    //arrays representing each day of the week, one being today, two being tomorrow etc
    var One = [String](repeating: "free", count: 15)
    var Two = [String](repeating: "free", count: 15)
    var Three = [String](repeating: "free", count: 15)
    var Four = [String](repeating: "free", count: 15)
    var Five = [String](repeating: "free", count: 15)
    var Six = [String](repeating: "free", count: 15)
    var Seven = [String](repeating: "free", count: 15)
    var DaysOfTheWeek: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    let testEvent = EventDetails(startDate: NSDate() as Date, endDate: NSDate() as Date, duration: 0)
    var EventArray = [EventDetails]()
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        ThisWeek.Instance.getMonth()
        findBestTime()
       // testDatabase()
    }
    
       func printTimeTables(array: [String])
    {
        for index in 0...14
        {
            print(array[index])
        }
        
        print("*******************")
    }
    
    
    func findBestTime()
    {
        
        
        let openingHour = 7
       // var tempOpeningHour = openingHour
        var start = NSDate()
        let unitFlags = Set<Calendar.Component>([.weekday])
        var day =  NSCalendar.current.dateComponents(unitFlags, from: start as Date)
        var tempDay = DaysOfTheWeek[day.weekday!-1]
        
        var dayCounter = 1
        
        print(tempDay)
        
        while(dayCounter <= 7)
        {
            //today = day 1
            print(dayCounter)
            switch(dayCounter)
            {
                case 1:
                    for index in 0...One.count - 1
                    {
                        let tempTime = index + 7
                        let tempTimeAsString = String(tempTime)
                        getStringFromDatabase(time: tempTimeAsString, todaysDay: tempDay, completion: { (stringToReturn) in
                            
                            print("complete 1")
                            if(self.One[index] == "free" && stringToReturn != "busy" && stringToReturn != "very-busy")
                            {
                                print("????????????????")
                                print(stringToReturn)
                                
                               self.reference.personalisedTimesArray.append(PersonalisedTimes(day: tempDay, time: tempTimeAsString, status: stringToReturn))
                            }
                            
                            print("complete")
                            print(self.reference.personalisedTimesArray)
                            
                        })
                    }
                    print("complete")
                    print(reference.personalisedTimesArray)
                  /*  getStringFromDatabase(time: <#T##Int#>, todaysDay: tempDay, completion: { (stringToReturn) in
                        <#code#>
                    })
                    testDatabase(todaysDay: tempDay, array: One, completion: { (arrayToReturn) in
                        //code when its complete
                        for i in 0...arrayToReturn.count
                        {
                            print(i)
                            self.reference.personalisedTimesArray.append(arrayToReturn[i])
                        }
                        
                        print("complete 1")
                    })
                                       print(tempDay)
                    print(dayCounter)
                case 2:
                    testDatabase(todaysDay: tempDay, array: Two, completion: { (arrayToReturn) in
                        for i in 0...arrayToReturn.count
                        {
                            self.reference.personalisedTimesArray.append(arrayToReturn[i])
                        }
                        print("complete 2")
                    })
                case 3:
                    testDatabase(todaysDay: tempDay, array: Three, completion: { (arrayToReturn) in
                        for i in 0...arrayToReturn.count
                        {
                            self.reference.personalisedTimesArray.append(arrayToReturn[i])
                        }

                        print("complete 3")
                    })
                case 4:
                    testDatabase(todaysDay: tempDay, array: Four, completion: { (arrayToReturn) in
                        for i in 0...arrayToReturn.count
                        {
                            self.reference.personalisedTimesArray.append(arrayToReturn[i])
                        }

                        print("complete 4")
                    })
                case 5:
                    testDatabase(todaysDay: tempDay, array: Five, completion: { (arrayToReturn) in
                        //code when its complete
                        for i in 0...arrayToReturn.count
                        {
                            self.reference.personalisedTimesArray.append(arrayToReturn[i])
                        }

                        print("complete 5")
                    })
                case 6:
                    testDatabase(todaysDay: tempDay, array: Six, completion: { (arrayToReturn) in
                        //code when its complete
                        for i in 0...arrayToReturn.count
                        {
                            self.reference.personalisedTimesArray.append(arrayToReturn[i])
                        }

                        print("complete 6")
                    })
                case 7:
                    testDatabase(todaysDay: tempDay, array: Seven, completion: { (arrayToReturn) in
                        //code when its complete
                        for i in 0...arrayToReturn.count
                        {
                            self.reference.personalisedTimesArray.append(arrayToReturn[i])
                        }

                        print("complete")
                    })*/
                default:
                    print(dayCounter)
            }
            
            
            
            //dayCounter = 8
        
            start = start.addingTimeInterval(60*60*24)
            day = NSCalendar.current.dateComponents(unitFlags, from: start as Date)
            tempDay = DaysOfTheWeek[day.weekday!-1]
            dayCounter = dayCounter + 1
            
            
            
        }
        
        
        
        
//print(reference.personalisedTimesArray)
            //    print(reference.personalisedTimesArray.count)
        
        
        
        
        
        
        
        
        
        
        
        
        //for today
      /*  for i in 0...One.count - 1
        {
            let temp = i + openingHour
            let time = String(temp)
            
            ref.child(monthType).child(tempDay).child(time).observe(.value, with: {(FIRDataSnapshot) in
                let tempStringFromDatabase = FIRDataSnapshot.value as? String ?? ""
                    
                if(self.One[i] == "free" && tempStringFromDatabase != "very-busy" && tempStringFromDatabase != "busy")
                {
                    self.personalisedTimesArray.append(PersonalisedTimes(day: tempDay, time: time, status: tempStringFromDatabase))
                    
                }
            })
        }*/
        
        
    }
    
    func getStringFromDatabase(time: String, todaysDay: String, completion: @escaping(_ stringToReturn: String)->())
    {
        
        let ref = reference.ref
        let stringToReturn = ""
       // let openingHour = 7
       // let tempTime = time + openingHour
     //   let timeAsString = String(tempTime)
        
        ref.child(monthType).child(todaysDay).child(time).observeSingleEvent(of: .value, with: { (snapshot) in
            let stringToReturn = snapshot.value as? String ?? ""
            print("___________________")
            print(stringToReturn)
            completion(stringToReturn)
            
        })
      //  completion(stringToReturn)
    }
    
    func testDatabase(todaysDay: String, array: [String], completion: @escaping (_ arrayToReturn: [PersonalisedTimes])->())
    {
        //let ref = FIRDatabase.database().reference()
        let ref = reference.ref
        let openingHour = 7
        print("in test database func")
        print(todaysDay)
        
    //    var arrayReference = self.reference.personalisedTimesArray
        var arrayToReturn = [PersonalisedTimes]()
        
        
        if(todaysDay != "Saturday" && todaysDay != "Sunday")
        {
            
        
        
        for i in 0...array.count - 1
        {
            print(i)
            let temp = i + openingHour
            let time = String(temp)
            
            
            
            ref.child(monthType).child(todaysDay).child(time).observeSingleEvent(of: .value, with: { (snapshot) in
                if let tempStringFromDatabase = snapshot.value as? String {
                    //  print(tempStringFromDatabase)
                    //   print("...")
                    
                    if(array[i] == "free" && tempStringFromDatabase != "very-busy" && tempStringFromDatabase != "busy")
                    {
                        arrayToReturn.append(PersonalisedTimes(day: todaysDay, time: time, status: tempStringFromDatabase))
                       // arrayReference.append(PersonalisedTimes(day: todaysDay, time: time, status: tempStringFromDatabase))
                        //print(array[i])
                    }}
                
                completion(arrayToReturn)
            })
            
            
            
            
            }
        }
    }
    
    

}

    //TIMETABLE VISUALISATION
    //[  0   ][   1  ]
    //[7:00am][8:00am][9:00am][10:00am][11:00am][12:00pm][1:00pm][2:00pm][3:00pm][4:00pm][5:00pm][6:00pm][7:00pm][8:00pm][9:00pm]


 
 

