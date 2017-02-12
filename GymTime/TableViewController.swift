//
//  TableViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 09/02/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit
import Firebase
import EventKit


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dataSourceArray = ["hello", "world"]
    
    let eventStore = EKEventStore()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        
        cell.textLabel?.text = dataSourceArray[indexPath.row]
        
        
    
        // set cell's detailTextLabel.text property
        return cell
    }
    
}
