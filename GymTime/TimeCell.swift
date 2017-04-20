//
//  TimeCell.swift
//  GymTime
//
//  Copyright © 2017 Laura Rundle. All rights reserved.
//  This represents a cell in the TableView that displays the suggested times.

import UIKit

class TimeCell: UITableViewCell {
    
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellStatusIndicator: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

        override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

  
    }

}
