//
//  WorkoutExerciseViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 8.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutExerciseViewController: UIViewController {
    @IBOutlet weak var extratextText:       UITextField!
    @IBOutlet weak var specialPickerView:   UIPickerView!
    @IBOutlet weak var unitSegmented:       UISegmentedControl!
    @IBOutlet weak var beltSwitch:          UISwitch!
    @IBOutlet weak var kneeWrapsSwitch:     UISwitch!
    @IBOutlet weak var shirtSwitch:         UISwitch!
    @IBOutlet weak var suitSwitch:          UISwitch!
    @IBOutlet weak var wristStrapsSwitch:   UISwitch!
    @IBOutlet weak var wristWrapsSwitch:    UISwitch!
    @IBOutlet weak var setsTableView:       UITableView!
    
    var exerciseIndex: Int?
    
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