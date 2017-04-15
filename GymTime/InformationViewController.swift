//
//  InformationViewController.swift
//  GymTime
//
//  Created by Laura Rundle on 14/04/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var mediumTrafficLabel: UILabel!
    @IBOutlet weak var lowTrafficLabel: UILabel!
    
    @IBOutlet weak var busyTrafficLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = "Gym Time is a tool to help you make the best of your work outs! We tell you the best times for you to go to the gym during the next 7 days. All we ask is that you have your Calendar up to date with all your lectures, meetings and lunch breaks scheduled. \n\n🏋🏾‍♀️🏋🏻🏋🏾‍♀️\n\nUse the preferences switches to let us know what data you would like to see. \n\n🏃🏻🏃🏼‍♀️🏃🏿\n\nUse the status indicator below to choose the best times, add to your Calendar and you're ready to go!"
        
        lowTrafficLabel.backgroundColor = UIColor(red:0.73, green:0.90, blue:0.40, alpha:1.0)
        mediumTrafficLabel.backgroundColor = UIColor(red:1.00, green:0.50, blue:0.00, alpha:1.0)
        busyTrafficLabel.backgroundColor = UIColor(red:0.94, green:0.21, blue:0.16, alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
