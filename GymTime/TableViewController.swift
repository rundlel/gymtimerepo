//
//  TableViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 25/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import Firebase


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let reference = FIRDatabase.database().reference()
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    var listOfTimesArray = [String]()
    
    var dateFormatter =  DateFormatter()
    var EventArray = [EventDetails]()

   
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.backgroundColor = .clear
        self.title = "BEST TIMES FOR YOU"
        
        if(ThisWeek.Instance.seeMoreTimes == false)
        {
            prepareDataForDisplay()
        }
        else
        {
            seeMoreAvailableTimes()
        }
        
        tableView.reloadData()
        
       // ThisWeek.Instance.getMonth()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
       /* let backgroundImage = UIImage(named: "Waves-geometric-vectors-background-material")
        let imageView = UIImageView(image: backgroundImage!)
        imageView.contentMode = .scaleAspectFill
        
        
        self.tableView.backgroundView = imageView
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)*/
        
    }
    
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  listOfTimesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
        
        cell.cellLabel.text = listOfTimesArray[indexPath.row]
        cell.backgroundColor = .clear
        
        cell.cellButton.tag = indexPath.row
        cell.cellButton.contentHorizontalAlignment = .right
        cell.cellButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.cellButton.addTarget(self, action: #selector(addToCalendarButton), for: .touchUpInside)
        cell.cellButton.setTitleColor(UIColor(red:0.93, green:0.96, blue:0.98, alpha:1.0), for: .disabled)
     
        return cell
    }
    
    func prepareDataForDisplay()
    {
        let today = NSDate()
        let unitFlags = Set<Calendar.Component>([.weekday])
        var day =  NSCalendar.current.dateComponents(unitFlags, from: today as Date)
        let todayDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
        var todayIsInWeekend = false
        
        if (todayDay == "Saturday" || todayDay == "Sunday")
        {
            todayIsInWeekend = true
        }
        
        if(ThisWeek.Instance.includeWeekend == true && ThisWeek.Instance.includeToday == true)
        {
            for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
            {
                let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                var tempTime:Int? = Int(tempPersonalisedTime.time)!
                var timeToString = String(tempTime!) + "am"
                
                if(Int(tempPersonalisedTime.time)! >= 12)
                {
                    if(Int(tempPersonalisedTime.time)! != 12)
                    {
                        tempTime = tempTime! - 12
                    }
                    
                    timeToString = String(tempTime!) + "pm"
                }
                if(tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium")
                {
                    let tempString = tempPersonalisedTime.day + " " + timeToString
                    listOfTimesArray.append(tempString)
                }
            }
        }
        else if(ThisWeek.Instance.includeWeekend == false && ThisWeek.Instance.includeToday == true)
        {
            
            if(todayIsInWeekend) //includeToday
            {
                
                for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
                {
                    let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                    var tempTime:Int? = Int(tempPersonalisedTime.time)!
                    var timeToString = String(tempTime!) + "am"
                    
                    if(Int(tempPersonalisedTime.time)! >= 12)
                    {
                        if(Int(tempPersonalisedTime.time)! != 12)
                        {
                            tempTime = tempTime! - 12
                        }
                        
                        timeToString = String(tempTime!) + "pm"
                    }
                    
                    if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium") && todayDay == "Saturday" && tempPersonalisedTime.day != "Sunday")
                    {
                        let tempString = tempPersonalisedTime.day + " " + timeToString
                        listOfTimesArray.append(tempString)
                    }
                    else if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium") && todayDay == "Sunday")
                    {
                        print(todayDay)
                        if(Int(tempPersonalisedTime.time)! >= 12)
                        {
                            if(Int(tempPersonalisedTime.time)! != 12)
                            {
                                tempTime = tempTime! - 12
                            }
                            
                            timeToString = String(tempTime!) + "pm"
                        }
                        if(tempPersonalisedTime.day != "Saturday")
                        {
                            let tempString = tempPersonalisedTime.day + " " + timeToString
                            print(tempString)
                            listOfTimesArray.append(tempString)
                            print(listOfTimesArray)
                        }
                    }
                }
            }
            else
            {
                for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
                {
                    let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                    var tempTime:Int? = Int(tempPersonalisedTime.time)!
                    var timeToString = String(tempTime!) + "am"
                    
                    if(Int(tempPersonalisedTime.time)! >= 12)
                    {
                        if(Int(tempPersonalisedTime.time)! != 12)
                        {
                            tempTime = tempTime! - 12
                        }
                        
                        timeToString = String(tempTime!) + "pm"
                    }
                    
                    if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium") && tempPersonalisedTime.day != "Saturday" && tempPersonalisedTime.day != "Sunday")
                    {
                        let tempString = tempPersonalisedTime.day + " " + timeToString
                        listOfTimesArray.append(tempString)
                    }
                }
            }
        }
        else if (ThisWeek.Instance.includeWeekend == true && ThisWeek.Instance.includeToday == false)
        {
            for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
            {
                let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                var tempTime:Int? = Int(tempPersonalisedTime.time)!
                var timeToString = String(tempTime!) + "am"
                
                if(Int(tempPersonalisedTime.time)! >= 12)
                {
                    if(Int(tempPersonalisedTime.time)! != 12)
                    {
                        tempTime = tempTime! - 12
                    }
                    
                    timeToString = String(tempTime!) + "pm"
                }
                
                if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium") && tempPersonalisedTime.day != todayDay)
                {
                    let tempString = tempPersonalisedTime.day + " " + timeToString
                    listOfTimesArray.append(tempString)
                }
            }
        }
        else if (ThisWeek.Instance.includeWeekend == false && ThisWeek.Instance.includeToday == false)
        {
            for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
            {
                let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                var tempTime:Int? = Int(tempPersonalisedTime.time)!
                var timeToString = String(tempTime!) + "am"
                
                
                if(Int(tempPersonalisedTime.time)! >= 12)
                {
                    if(Int(tempPersonalisedTime.time)! != 12)
                    {
                        tempTime = tempTime! - 12
                    }
                    
                    timeToString = String(tempTime!) + "pm"
                }
                
                if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium") && tempPersonalisedTime.day != todayDay && tempPersonalisedTime.day != "Saturday" && tempPersonalisedTime.day != "Sunday")
                {
                    let tempString = tempPersonalisedTime.day + " " + timeToString
                    listOfTimesArray.append(tempString)
                }
            }
            
        }
    }
    
    
    func seeMoreAvailableTimes(){
        let today = NSDate()
        let unitFlags = Set<Calendar.Component>([.weekday])
        var day =  NSCalendar.current.dateComponents(unitFlags, from: today as Date)
        let todayDay = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
        var todayIsInWeekend = false
        
        if (todayDay == "Saturday" || todayDay == "Sunday")
        {
            todayIsInWeekend = true
        }
        
        if(ThisWeek.Instance.includeWeekend == true && ThisWeek.Instance.includeToday == true)
        {
            for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
            {
                let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                var tempTime:Int? = Int(tempPersonalisedTime.time)!
                var timeToString = String(tempTime!) + "am"
                
                if(Int(tempPersonalisedTime.time)! >= 12)
                {
                    if(Int(tempPersonalisedTime.time)! != 12)
                    {
                        tempTime = tempTime! - 12
                    }
                    
                    timeToString = String(tempTime!) + "pm"
                }
                if(tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium" || tempPersonalisedTime.status == "busy")
                {
                    let tempString = tempPersonalisedTime.day + " " + timeToString
                    listOfTimesArray.append(tempString)
                }
            }
        }
        else if(ThisWeek.Instance.includeWeekend == false && ThisWeek.Instance.includeToday == true)
        {
            
            if(todayIsInWeekend) //includeToday
            {
                
                for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
                {
                    let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                    var tempTime:Int? = Int(tempPersonalisedTime.time)!
                    var timeToString = String(tempTime!) + "am"
                    
                    if(Int(tempPersonalisedTime.time)! >= 12)
                    {
                        if(Int(tempPersonalisedTime.time)! != 12)
                        {
                            tempTime = tempTime! - 12
                        }
                        
                        timeToString = String(tempTime!) + "pm"
                    }
                    if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium" || tempPersonalisedTime.status == "busy") && todayDay == "Saturday" && tempPersonalisedTime.day != "Sunday")
                    {
                        let tempString = tempPersonalisedTime.day + " " + timeToString
                        listOfTimesArray.append(tempString)
                    }
                    else if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium" || tempPersonalisedTime.status == "busy")  && todayDay == "Sunday")
                    {
                        print(todayDay)
                        if(Int(tempPersonalisedTime.time)! >= 12)
                        {
                            if(Int(tempPersonalisedTime.time)! != 12)
                            {
                                tempTime = tempTime! - 12
                            }
                            
                            timeToString = String(tempTime!) + "pm"
                        }
                        if(tempPersonalisedTime.day != "Saturday")
                        {
                            let tempString = tempPersonalisedTime.day + " " + timeToString
                            print(tempString)
                            listOfTimesArray.append(tempString)
                            print(listOfTimesArray)
                        }
                    }
                }
            }
            else
            {
                for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
                {
                    let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                    var tempTime:Int? = Int(tempPersonalisedTime.time)!
                    var timeToString = String(tempTime!) + "am"
                    
                    if(Int(tempPersonalisedTime.time)! >= 12)
                    {
                        if(Int(tempPersonalisedTime.time)! != 12)
                        {
                            tempTime = tempTime! - 12
                        }
                        
                        timeToString = String(tempTime!) + "pm"
                    }
                    
                    if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium" || tempPersonalisedTime.status == "busy") && tempPersonalisedTime.day != "Saturday" && tempPersonalisedTime.day != "Sunday")
                    {
                        let tempString = tempPersonalisedTime.day + " " + timeToString
                        listOfTimesArray.append(tempString)
                    }
                }
            }
        }
        else if (ThisWeek.Instance.includeWeekend == true && ThisWeek.Instance.includeToday == false)
        {
            for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
            {
                let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                var tempTime:Int? = Int(tempPersonalisedTime.time)!
                var timeToString = String(tempTime!) + "am"
                
                if(Int(tempPersonalisedTime.time)! >= 12)
                {
                    if(Int(tempPersonalisedTime.time)! != 12)
                    {
                        tempTime = tempTime! - 12
                    }
                    
                    timeToString = String(tempTime!) + "pm"
                }
                if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium" || tempPersonalisedTime.status == "busy") && tempPersonalisedTime.day != todayDay)
                {
                    let tempString = tempPersonalisedTime.day + " " + timeToString
                    listOfTimesArray.append(tempString)
                }
            }
        }
        else if (ThisWeek.Instance.includeWeekend == false && ThisWeek.Instance.includeToday == false)
        {
            for i in 0...ThisWeek.Instance.personalisedTimesArray.count - 1
            {
                let tempPersonalisedTime = ThisWeek.Instance.personalisedTimesArray[i]
                var tempTime:Int? = Int(tempPersonalisedTime.time)!
                var timeToString = String(tempTime!) + "am"
                
                if(Int(tempPersonalisedTime.time)! >= 12)
                {
                    if(Int(tempPersonalisedTime.time)! != 12)
                    {
                        tempTime = tempTime! - 12
                    }
                    
                    timeToString = String(tempTime!) + "pm"
                }
                
                if((tempPersonalisedTime.status == "good" || tempPersonalisedTime.status == "medium" || tempPersonalisedTime.status == "busy") && tempPersonalisedTime.day != todayDay && tempPersonalisedTime.day != "Saturday" && tempPersonalisedTime.day != "Sunday")
                {
                    let tempString = tempPersonalisedTime.day + " " + timeToString
                    listOfTimesArray.append(tempString)
                }
            }
            
        }
        
    }
    
    @IBAction func seeMoreTimes(_ sender: Any) {
        print("reload")
        listOfTimesArray.removeAll()
        seeMoreAvailableTimes()
        ThisWeek.Instance.seeMoreTimes = true
        tableView.reloadData()
    }
    
    
    @IBAction func addToCalendarButton(_ sender: UIButton)
    {
     //  sender.setTitleColor(UIColor(red:0.93, green:0.96, blue:0.98, alpha:1.0),for: .normal)
        
        let arrayIndex = sender.tag
        let temp =  listOfTimesArray[arrayIndex]
        
        let indexPath = NSIndexPath(row: (sender as AnyObject).tag, section: 0)
        let currentCell = self.tableView.cellForRow(at: indexPath as IndexPath) as! TimeCell
        currentCell.cellButton.isEnabled = false
        
        
        
       // cell.cellButton.
       // cell.cellButton.viewWithTag(arrayIndex)?.isHidden = true
       //  .isEnabled = false
        
        var whileLoopVariable = true
        var today = NSDate()
        let unitFlags = Set<Calendar.Component>([.weekday, .hour, .year, .month, .day])
        var day =  NSCalendar.current.dateComponents(unitFlags, from: today as Date)
        var dayString = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
        
        var timezoneString = "GMT"
        let timezone = NSTimeZone.local
        if(timezone.isDaylightSavingTime(for: today as Date))
        {
            timezoneString = "BST"
        }
        
        
        while(whileLoopVariable)
        {
            if(temp.range(of: dayString) != nil) //if exists
            {
                whileLoopVariable = false
            }
            else
            {
                today = today.addingTimeInterval(60*60*24)
                day =  NSCalendar.current.dateComponents(unitFlags, from: today as Date)
                dayString = ThisWeek.Instance.DaysOfTheWeek[day.weekday!-1]
            }
        }
        let year = day.year
        let month = day.month
        let date = day.day
        var charAtIndex: Character = "a"
        var stringTest = ""
        var charAtIndexAsNumber:Int? = 0
        
        let dayLength = dayString.characters.count + 1
        if((temp.range(of: "10") != nil) || temp.range(of: "11") != nil || temp.range(of: "12") != nil)
        {
            let dayLength2 = dayString.characters.count + 2
            charAtIndex = temp[temp.index(temp.startIndex, offsetBy: dayLength)]
            let charAtIndex2 = temp[temp.index(temp.startIndex, offsetBy: dayLength2)]
            stringTest = String(charAtIndex)
            let Stringtest2 = String(charAtIndex2)
            stringTest = stringTest + Stringtest2
            print(stringTest)
            charAtIndexAsNumber = Int(stringTest)!
            print(charAtIndexAsNumber ?? 0)
            
        }
        else
        {
            charAtIndex = temp[temp.index(temp.startIndex, offsetBy: dayLength)]
            stringTest = String(charAtIndex)
            print(charAtIndex)
            charAtIndexAsNumber = Int(stringTest)!
            print(charAtIndexAsNumber ?? 0)
        }
        
        if(temp.range(of: "pm") != nil)
        {
            if(charAtIndexAsNumber != 12)
            {
                charAtIndexAsNumber = charAtIndexAsNumber! + 12
            }
        }
        let databaseTimeString = String(charAtIndexAsNumber!)
        let yearAsString = String(year!)
        let monthAsString = String(month!)
        let dayAsString = String(date!)
        let timeAsString = String(charAtIndexAsNumber!)
        
        
        let dateAsString = yearAsString + "-" + monthAsString + "-" + dayAsString + " " + timeAsString + ":" + "00" + ":00"
        
        let ISO8601DateFormatter = DateFormatter()
        ISO8601DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        ISO8601DateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        ISO8601DateFormatter.timeZone = TimeZone(abbreviation: timezoneString)
        
        
        let dateForGym = ISO8601DateFormatter.date(from: dateAsString)
        
        let eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if(granted && error == nil)
            {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "GymTime!"
                
                event.startDate = dateForGym!
                event.endDate = dateForGym!.addingTimeInterval(60*60*1)
                event.calendar = eventStore.defaultCalendarForNewEvents
                do
                {
                    try eventStore.save(event, span: .thisEvent)
                }catch let error as NSError
                {
                    print("save failed : \(error)")
                }
                print("event saved")
            }
            else
            {
                print("failed to save: \(error)")
            }
            
        }
        
        
        ref = FIRDatabase.database().reference()
        let tempToday = NSDate()
        let tempTodayComponents = NSCalendar.current.dateComponents(unitFlags, from: tempToday as Date)
        var tempTodayDay = tempTodayComponents.day
        if(tempTodayDay != 1)
        {
            tempTodayDay = tempTodayDay! - 1
            
          //  let tempTime =
           for i in 7...21
           {
                let tempTime = String(i)
                ref.child("Tracking").child(String(tempTodayDay!)).child(tempTime).setValue(0)
           }
        }
        else
        {
            for i in 7...21
            {
                let tempTime = String(i)
                ref.child("Tracking").child("30").child(tempTime).setValue(0)
                ref.child("Tracking").child("31").child(tempTime).setValue(0)
            }

        }
        
       // let user = FIRAuth.auth()?.currentUser
        
        
        ref.child("Tracking").child(dayAsString).child(databaseTimeString).observeSingleEvent(of: .value, with: { (snapshot) in
            var intToReturn = snapshot.value as? Int ?? 0
            intToReturn = intToReturn + 1
            var chld = stringTest
            
            self.ref.child("Tracking").child(dayAsString).child(databaseTimeString).setValue(intToReturn)
        })
        
        
        
       
    }

        
        
}
 
    


    

