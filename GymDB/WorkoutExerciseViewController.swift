//
//  WorkoutExerciseViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 8.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var navigationBar:       UINavigationBar!
    @IBOutlet weak var extratextText:       UITextField!
    @IBOutlet weak var specialPickerView:   UIPickerView!
    @IBOutlet weak var unitSegmented:       UISegmentedControl!
    @IBOutlet weak var beltSwitch:          UISwitch!
    @IBOutlet weak var kneeWrapsSwitch:     UISwitch!
    @IBOutlet weak var shirtSwitch:         UISwitch!
    @IBOutlet weak var suitSwitch:          UISwitch!
    @IBOutlet weak var wristStrapsSwitch:   UISwitch!
    @IBOutlet weak var wristWrapsSwitch:    UISwitch!
    @IBOutlet weak var editButton:          UIButton!
    @IBOutlet weak var setsTableView:       UITableView!
    
    var exerciseIndex:  Int?
    var exercise:       WorkoutExercise!
    var special:        [Special]           = Special.allValues
    var uiInit:         Bool                = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.uiInit {
            var unit: Unit = .KG
            if let default_unit = UserCache.user?.default_unit {
                unit = default_unit
            }
            
            self.exercise = WorkoutExercise(unit: unit, extratext: nil, special: nil, gearBelt: 0, gearKneeWraps: 0, gearShirt: 0, gearSuit: 0, gearWristStraps: 0, gearWristWraps: 0, sets: nil)
            
            if let exerciseIndex = self.exerciseIndex {
                if let exercises = WorkoutCache.workout?.exercises {
                    if exercises.count > exerciseIndex {
                        let tmp = exercises[exerciseIndex]
                        
                        // Clone exercise
                        self.exercise.unit             = tmp.unit
                        self.exercise.extratext        = tmp.extratext
                        self.exercise.special          = tmp.special
                        self.exercise.gearBelt         = tmp.gearBelt
                        self.exercise.gearKneeWraps    = tmp.gearKneeWraps
                        self.exercise.gearShirt        = tmp.gearShirt
                        self.exercise.gearSuit         = tmp.gearSuit
                        self.exercise.gearWristStraps  = tmp.gearWristStraps
                        self.exercise.gearWristWraps   = tmp.gearWristWraps
                        
                        // Clone sets
                        if let sets = tmp.sets {
                            self.exercise.sets = [WorkoutExerciseSet]()
                            for set in sets {
                                self.exercise.sets!.append(
                                    WorkoutExerciseSet(
                                        exerciseId:         set.exerciseId,
                                        repetitions:        set.repetitions,
                                        weightKG:           set.weightKG,
                                        weightLB:           set.weightLB,
                                        repetitionsType:    set.repetitionsType,
                                        barbellType:        set.barbellType,
                                        restIntervalSec:    set.restIntervalSec
                                    )
                                )
                            }
                        }
                    } else {
                        self.exerciseIndex = nil
                    }
                } else {
                    self.exerciseIndex = nil
                }
            }
            
            self.setViewUI()
            self.uiInit = true
        } else if self.exercise.sets != nil {
            self.setsTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.special.count+1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {        
        var result = ""
        
        if row == 0 {
            result = "- Not selected -"
        } else {
            result = self.special[row-1].description
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        
        if self.exercise != nil {
            if self.exercise.sets != nil {
                result = self.exercise.sets!.count
            }
        }
        
        if result > 0 {
            self.editButton.enabled = true
        } else {
            self.editButton.enabled = false
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutExerciseCell", forIndexPath: indexPath) as WorkoutExerciseTableViewCell
        
        if self.exercise != nil {
            if let set = self.exercise.sets?[indexPath.row] {
                var no = indexPath.row+1
                
                cell.noLabel.text = ("\(no).")
                cell.repsLabel.text = String(set.repetitions)
                
                var exerciseName = ""
                if let exercise = ExerciseCache.findByExerciseId(set.exerciseId) {
                    exerciseName = exercise.name
                }
                
                if let barbellType = set.barbellType {
                    exerciseName += " (" + barbellType.description + ")"
                }
                
                cell.exerciseLabel.text = exerciseName
                
                var weight = set.weightKG
                if self.exercise.unit == .LB {
                    weight = set.weightLB
                }
                    
                cell.weightLabel.text = NSString(format: "%.2f", weight)+" ("+self.exercise.unit.description+")"
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.exercise.sets!.removeAtIndex(indexPath.row)
            
            if self.exercise.sets!.count == 0 {
                self.exercise.sets = nil
            }
            
            tableView.reloadData()
        })
        
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let set = self.exercise.sets![sourceIndexPath.row]
        
        self.exercise.sets!.removeAtIndex(sourceIndexPath.row)
        self.exercise.sets!.insert(set, atIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.showWorkoutExerciseSet(indexPath.row)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func setViewUI() {
        var no = 1
        if let index = self.exerciseIndex {
            no = index+1
        } else if let index = WorkoutCache.workout?.exercises?.count {
            no = index+1
        }
        
        self.navigationBar.topItem?.title = "\(no). Exercise"
        
        for var i = 0; i < self.unitSegmented.numberOfSegments; i++ {
            if self.exercise.unit.rawValue == self.unitSegmented.titleForSegmentAtIndex(i)!.lowercaseString {
                self.unitSegmented.selectedSegmentIndex = i
                break
            }
        }
        
        self.extratextText.text = self.exercise.extratext
        
        if let special = self.exercise.special {
            if let key = find(self.special, special) {
                self.specialPickerView.selectRow(key+1, inComponent: 0, animated: false)
            }
        }
        
        if self.exercise.gearBelt == 1 {
            self.beltSwitch.setOn(true, animated: false)
        } else {
            self.beltSwitch.setOn(false, animated: false)
        }
        
        if self.exercise.gearKneeWraps == 1 {
            self.kneeWrapsSwitch.setOn(true, animated: false)
        } else {
            self.kneeWrapsSwitch.setOn(false, animated: false)
        }
        
        if self.exercise.gearShirt == 1 {
            self.shirtSwitch.setOn(true, animated: false)
        } else {
            self.shirtSwitch.setOn(false, animated: false)
        }
        
        if self.exercise.gearSuit == 1 {
            self.suitSwitch.setOn(true, animated: false)
        } else {
            self.suitSwitch.setOn(false, animated: false)
        }
        
        if self.exercise.gearWristStraps == 1 {
            self.wristStrapsSwitch.setOn(true, animated: false)
        } else {
            self.wristStrapsSwitch.setOn(false, animated: false)
        }
        
        if self.exercise.gearWristWraps == 1 {
            self.wristWrapsSwitch.setOn(true, animated: false)
        } else {
            self.wristWrapsSwitch.setOn(false, animated: false)
        }
        
        if self.exercise.sets != nil {
            self.setsTableView.reloadData()
        }
    }
    
    func showWorkoutExerciseSet(setIndex: Int?) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("workoutExerciseSetViewController") as WorkoutExerciseSetViewController
        
        viewController.exercise = self.exercise
        viewController.setIndex = setIndex
        
        self.presentViewController(viewController, animated: false, completion: nil)
    }
        
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func done() {        
        if self.extratextText.text != "" {
            self.exercise.extratext = self.extratextText.text
        } else {
            self.exercise.extratext = nil
        }
        
        let selected = self.specialPickerView.selectedRowInComponent(0)
        if selected == 0 {
            self.exercise.special = nil
        } else {
            self.exercise.special = self.special[selected-1]
        }
        
        self.exercise.gearBelt          = self.beltSwitch.on        ? 1 : 0
        self.exercise.gearKneeWraps     = self.kneeWrapsSwitch.on   ? 1 : 0
        self.exercise.gearShirt         = self.shirtSwitch.on       ? 1 : 0
        self.exercise.gearSuit          = self.suitSwitch.on        ? 1 : 0
        self.exercise.gearWristStraps   = self.wristStrapsSwitch.on ? 1 : 0
        self.exercise.gearWristWraps    = self.wristWrapsSwitch.on  ? 1 : 0
        
        var append = true
        
        if let exerciseIndex = self.exerciseIndex {
            if let exercises = WorkoutCache.workout?.exercises {
                if exercises.count > exerciseIndex {
                    WorkoutCache.workout!.exercises![exerciseIndex] = self.exercise
                    append = false
                }
            }
        }
        
        if append {
            if WorkoutCache.workout!.exercises == nil {
                WorkoutCache.workout!.exercises = [WorkoutExercise]()
            }
            
            WorkoutCache.workout!.exercises!.append(self.exercise)
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func addSet() {
        self.showWorkoutExerciseSet(nil)
    }
    
    @IBAction func edit() {
        if self.setsTableView.editing {
            self.editButton.setTitle("Edit", forState: .Normal)
            
            self.setsTableView.setEditing(false, animated: false)
            self.setsTableView.reloadData()
        } else {
            self.editButton.setTitle("Done", forState: .Normal)
            
            self.setsTableView.setEditing(true, animated: false)
        }
    }
    
    @IBAction func unitValueChanged() {
        let unit = Unit.fromString(self.unitSegmented.titleForSegmentAtIndex(self.unitSegmented.selectedSegmentIndex)!.lowercaseString)!
        
        self.exercise.unit = unit
        self.setsTableView.reloadData()
    }
}