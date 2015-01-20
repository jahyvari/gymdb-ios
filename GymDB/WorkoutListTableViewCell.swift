//
//  WorkoutListTableViewCell.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 20.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutListTableViewCell: UITableViewCell {
    @IBOutlet weak var extratextLabel:  UILabel!
    @IBOutlet weak var dateLabel:       UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
