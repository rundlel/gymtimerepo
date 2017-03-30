//
//  TimeCell.swift
//  GymTime
//
//  Created by Laura Rundle on 30/03/2017.
//  Copyright © 2017 Laura Rundle. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var cellLabel: UILabel!
    

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
