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
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        print("back button clicked")
    }
    @IBOutlet weak var NavigationItem: UINavigationBar!
    let reference = FIRDatabase.database().reference()
    
    
    @IBOutlet weak var tableView: UITableView!
    var listOfTimesArray = [String]()
    
    var dateFormatter =  DateFormatter()
    var EventArray = [EventDetails]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDataForDisplay()
        
        ThisWeek.Instance.getMonth()
        self.title = "Times"
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
       /* let backgroundImage = UIImage(named: "Waves-geometric-vectors-background-material")
        let imageView = UIImageView(image: backgroundImage!)
        imageView.contentMode = .scaleAspectFill
        
        
        self.tableView.backgroundView = imageView
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)*/
        
        self.tableView.backgroundColor = .clear
        

    }
    
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  listOfTimesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")! as UITableViewCell
        
        cell.textLabel?.text =  listOfTimesArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Tamil Sangam MN", size: 20)
        cell.textLabel?.textColor = UIColor(red:0.19, green:0.47, blue:0.65, alpha:1.0)
        cell.backgroundColor = .clear
      //  cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        let button = UIButton()
        button.frame = (frame: CGRect(x: cell.frame.size.width - 150, y: 1, width: 150, height: 50))
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont(name: "Tamil Sangam MN", size: 13)
        
       // button.titleLabel?.textColor = UIColor(red:0.19, green:0.48, blue:0.66, alpha:1.0)
        button.setTitle("ADD TO CALENDAR", for: .normal)
        button.setTitleColor(UIColor(red:0.19, green:0.47, blue:0.65, alpha:1.0), for: .normal)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        cell.addSubview(button)
        
            
        return cell
    }
 
    func buttonClicked(sender : UIButton!) {
        
        
        
        print("Clicked!")
        
        let arrayIndex = sender.tag
        let temp =  listOfTimesArray[arrayIndex]
    
        
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
        
        var charAtIndexAsNumber:Int? = 0
        
        let dayLength = dayString.characters.count + 1
        if((temp.range(of: "10") != nil) || temp.range(of: "11") != nil || temp.range(of: "12") != nil)
        {
            let dayLength2 = dayString.characters.count + 2
            let charAtIndex = temp[temp.index(temp.startIndex, offsetBy: dayLength)]
            let charAtIndex2 = temp[temp.index(temp.startIndex, offsetBy: dayLength2)]
            var Stringtest = String(charAtIndex)
            let Stringtest2 = String(charAtIndex2)
            Stringtest = Stringtest + Stringtest2
            print(Stringtest)
            charAtIndexAsNumber = Int(Stringtest)!
            print(charAtIndexAsNumber ?? 0)
            
        }
        else
        {
            let charAtIndex = temp[temp.index(temp.startIndex, offsetBy: dayLength)]
            let stringTest = String(charAtIndex)
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
        
        let yearAsString = String(year!)
        let monthAsString = String(month!)
        let dayAsString = String(date!)
        let timeAsString = String(charAtIndexAsNumber!)
        /*var dateAsString = ""
        
    
        if(charAtIndexAsNumber! < 12)
        {
            dateAsString = yearAsString + "-" + monthAsString + "-" + dayAsString + " " + timeAsString + ":" + "00" + ":00"
        }
        else{
            dateAsString = yearAsString + "-" + monthAsString + "-" + dayAsString + " " + timeAsString + ":" + "00" + ":00"
        }*/
        
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
                if(tempPersonalisedTime.status == "good")
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
                    
                    if(Int(tempPersonalisedTime.time)! > 12)
                    {
                        tempTime = tempTime! - 12
                        timeToString = String(tempTime!) + "pm"
                        
                    }
                    
                    if(tempPersonalisedTime.status == "good" && todayDay == "Saturday" && tempPersonalisedTime.day != "Sunday")
                    {
                        let tempString = tempPersonalisedTime.day + " " + timeToString
                         listOfTimesArray.append(tempString)
                    }
                    else if(tempPersonalisedTime.status == "good" && todayDay == "Sunday")
                    {
                        print(todayDay)
                        if(Int(tempPersonalisedTime.time)! > 12)
                        {
                            tempTime = tempTime! - 12
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
                    
                    if(Int(tempPersonalisedTime.time)! > 12)
                    {
                        tempTime = tempTime! - 12
                        timeToString = String(tempTime!) + "pm"
                    }
                    
                    if(tempPersonalisedTime.status == "good" && tempPersonalisedTime.day != "Saturday" && tempPersonalisedTime.day != "Sunday")
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
                
                if(Int(tempPersonalisedTime.time)! > 12)
                {
                    tempTime = tempTime! - 12
                    timeToString = String(tempTime!) + "pm"
                }
                
                    if(tempPersonalisedTime.status == "good" && tempPersonalisedTime.day != todayDay)
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
                
                if(Int(tempPersonalisedTime.time)! > 12)
                {
                    tempTime = tempTime! - 12
                    timeToString = String(tempTime!) + "pm"
                }
                
                if(tempPersonalisedTime.status == "good" && tempPersonalisedTime.day != todayDay && tempPersonalisedTime.day != "Saturday" && tempPersonalisedTime.day != "Sunday")
                {
                        let tempString = tempPersonalisedTime.day + " " + timeToString
                         listOfTimesArray.append(tempString)
                }
            }

        }
    }
}



    

