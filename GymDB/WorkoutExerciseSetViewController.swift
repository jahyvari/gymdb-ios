//
//  WorkoutExerciseSetViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 13.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutExerciseSetViewController: UIViewController {
    @IBOutlet weak var exerciseTextLabel:   UILabel!
    @IBOutlet weak var repsText:            UITextField!
    @IBOutlet weak var weightUnitLabel:     UILabel!
    @IBOutlet weak var weightText:          UITextField!
    @IBOutlet weak var repTypePicker:       UIPickerView!
    @IBOutlet weak var restPicker:          UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
