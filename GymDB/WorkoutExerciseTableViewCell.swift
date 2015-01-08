//
//  WorkoutExerciseTableViewCell.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 8.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutExerciseTableViewCell: UITableViewCell {
    @IBOutlet weak var noLabel:         UILabel!
    @IBOutlet weak var exerciseLabel:   UILabel!
    @IBOutlet weak var repsLabel:       UILabel!
    @IBOutlet weak var weightLabel:     UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}