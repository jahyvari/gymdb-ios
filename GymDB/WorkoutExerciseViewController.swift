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
    
    var exerciseIndex:  Int?
    var exercise:       WorkoutExercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let exerciseIndex = self.exerciseIndex {
            if let exercise = WorkoutCache.workout?.exercises?[exerciseIndex] {
                self.exercise = exercise
                
                // FIXME: Rest of the UI elements...
                self.extratextText.text = self.exercise!.extratext
                
                self.setsTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        
        if self.exercise != nil {
            if self.exercise!.sets != nil {
                result = self.exercise!.sets!.count
            }
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutExerciseCell", forIndexPath: indexPath) as WorkoutExerciseTableViewCell
        
        if self.exercise != nil {
            if let set = self.exercise!.sets?[indexPath.row] {
                var no = indexPath.row+1
                
                cell.noLabel.text = ("\(no).")
                cell.repsLabel.text = String(set.repetitions)
                    
                var weight = set.weightKG
                if self.exercise!.unit == .LB {
                    weight = set.weightLB
                }
                    
                cell.weightLabel.text = NSString(format: "%.2f", weight)
            }
        }
        
        return cell
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}