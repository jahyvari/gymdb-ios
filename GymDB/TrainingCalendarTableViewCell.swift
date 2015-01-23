//
//  TrainingCalendarTableViewCell.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 23.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class TrainingCalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var trainingProgramLabel:    UILabel!
    @IBOutlet weak var templateLabel:           UILabel!
    @IBOutlet weak var workoutDateLabel:        UILabel!
    @IBOutlet weak var todayLabel:              UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
