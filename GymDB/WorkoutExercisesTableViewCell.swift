//
//  WorkoutExercisesTableViewCell.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 6.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutExercisesTableViewCell: UITableViewCell {
    @IBOutlet weak var noLabel:         UILabel!
    @IBOutlet weak var extratextLabel:  UILabel!
    @IBOutlet weak var setsLabel:       UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
