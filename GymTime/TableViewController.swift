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
    
    
    @IBOutlet weak var tableView: UITableView!
    var dataSourceArray = [String]()
    
    var dateFormatter =  DateFormatter()
    var EventArray = [EventDetails]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDataForDisplay()
        
        ThisWeek.Instance.getMonth()

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
        
        return dataSourceArray.count // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")! as UITableViewCell
        
        cell.textLabel?.text = dataSourceArray[indexPath.row]
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
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        cell.addSubview(button)
        
            
        return cell
    }
    func buttonClicked(sender : UIButton!) {
        print("Clicked!")
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
                    
                if(Int(tempPersonalisedTime.time)! > 12)
                {
                    tempTime = tempTime! - 12
                    timeToString = String(tempTime!) + "pm"
                }
                if(tempPersonalisedTime.status == "good")
                {
                    let tempString = tempPersonalisedTime.day + " " + timeToString
                    dataSourceArray.append(tempString)
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
                        dataSourceArray.append(tempString)
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
                            dataSourceArray.append(tempString)
                            print(dataSourceArray)
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
                        dataSourceArray.append(tempString)
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
                            dataSourceArray.append(tempString)
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
                        dataSourceArray.append(tempString)
                }
            }

        }
    }
}



    

