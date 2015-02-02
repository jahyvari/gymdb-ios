//
//  TemplateExerciseSetTableViewCell.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 2.2.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class TemplateExerciseSetTableViewCell: UITableViewCell {
    @IBOutlet weak var setNoLabel:              UILabel!
    @IBOutlet weak var exerciseNameLabel:       UILabel!
    @IBOutlet weak var repsLabel:               UILabel!
    @IBOutlet weak var repsEndLabel:            UILabel!
    @IBOutlet weak var weightLabel:             UILabel!
    @IBOutlet weak var restLabel:               UILabel!
    @IBOutlet weak var repTypeLabel:            UILabel!
    @IBOutlet weak var oneRepMaxPercentLabel:   UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
