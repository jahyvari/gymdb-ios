//
//  WorkoutExerciseSetViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 13.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutExerciseSetViewController: UIViewController {
    @IBOutlet weak var navigationBar:   UINavigationBar!
    @IBOutlet weak var exerciseText:    UITextField!
    @IBOutlet weak var repsText:        UITextField!
    @IBOutlet weak var weightUnitLabel: UILabel!
    @IBOutlet weak var weightText:      UITextField!
    @IBOutlet weak var repTypePicker:   UIPickerView!
    @IBOutlet weak var restPicker:      UIPickerView!
    
    var exercise:       WorkoutExercise!
    var exerciseSet:    WorkoutExerciseSet!
    var setIndex:       Int?
    var repType:        [RepetionsType]     = RepetionsType.allValues
    var restTime:       [UInt16]            = [UInt16]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for var i: UInt16 = 0; i <= 600; i += 10 {
            self.restTime.append(i)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var exercise = ExerciseCache.getFirstExercise()
        if exercise == nil {
            let alert = UIAlertController(title: "Cannot load exercise cache!", message: nil, preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
                self.dismissViewControllerAnimated(false, completion: nil)
            }))
            alert.view.tintColor = UIColor.redColor()
            
            self.presentViewController(alert, animated: false, completion: nil)
        } else {
            var barbellType: BarbellType?
            if exercise!.exerciseCategory == .Barbell {
                barbellType = .StandardBar
            }
            
            self.exerciseSet = WorkoutExerciseSet(exerciseId: exercise!.id, repetitions: 0, weightKG: 0, weightLB: 0, repetitionsType: .Normal, barbellType: barbellType, restIntervalSec: 120)
            
            if let index = self.setIndex {
                if self.exercise.sets != nil && self.exercise.sets!.count > index {
                    let tmp = self.exercise.sets![index]
                    
                    // Close exercise set
                    self.exerciseSet.exerciseId        = tmp.exerciseId
                    self.exerciseSet.repetitions       = tmp.repetitions
                    self.exerciseSet.weightKG          = tmp.weightKG
                    self.exerciseSet.weightLB          = tmp.weightLB
                    self.exerciseSet.repetitionsType   = tmp.repetitionsType
                    self.exerciseSet.barbellType       = tmp.barbellType
                    self.exerciseSet.restIntervalSec   = tmp.restIntervalSec
                }
            }
            
            self.setViewUI()
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
        if pickerView.tag == 100 {
            return self.repType.count
        } else {
            return self.restTime.count+1
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var result = ""
        
        if pickerView.tag == 100 {
            result = self.repType[row].description
        } else {
            if row == 0 {
                result = "- Not selected -"
            } else {
                var time = self.restTime[row-1]
                
                if time < 60 {
                    result = "\(time) sec"
                } else {
                    var tmp = Double(time)
                    
                    var minutes = floor(tmp / 60)
                    var seconds = tmp % 60
                    
                    result = NSString(format: "%.0f", minutes) + " min"
                    if seconds > 0.0 {
                        result = result + " " + NSString(format: "%.0f", seconds) + " sec"
                    }
                }
            }
        }
        
        return result
    }
    
    func setViewUI() {
        var no = 1
        if let index = self.setIndex {
            no = index+1
        } else if let index = self.exercise.sets?.count {
            no = index+1
        }
        
        self.navigationBar.topItem?.title = "\(no). Set"
        
        var exercise = ExerciseCache.findByExerciseId(self.exerciseSet.exerciseId)
        
        var weight = self.exerciseSet.weightKG
        if self.exercise.unit == .LB {
            var weight = self.exerciseSet.weightLB
        }
        
        var exerciseName = exercise!.name
        if self.exerciseSet.barbellType != nil {
            exerciseName = exerciseName + " (" + self.exerciseSet.barbellType!.description + ")"
        }
        
        self.exerciseText.text  = exerciseName
        self.repsText.text      = String(self.exerciseSet.repetitions)
        self.weightText.text    = NSString(format: "%.2f", weight)
        
        for (key,value) in enumerate(self.repType) {
            if value == self.exerciseSet.repetitionsType {
                self.repTypePicker.selectRow(key, inComponent: 0, animated: false)
                break
            }
        }
        
        if let restIntervalSec = self.exerciseSet.restIntervalSec {
            for (key,value) in enumerate(self.restTime) {
                if value == restIntervalSec {
                    self.restPicker.selectRow(key+1, inComponent: 0, animated: false)
                    break
                }
            }
        }
    }
    
    func validateReps() -> Bool {
        var result = false
        
        if let reps = NSNumberFormatter().numberFromString(self.repsText.text) {
            if reps.integerValue >= 0 && reps.integerValue <= 65535 {
                result = true
            }
        }
        
        return result
    }
    
    func validateWeight() -> Bool {
        var result = false
        
        if let reps = NSNumberFormatter().numberFromString(self.weightText.text) {
            if reps.floatValue >= 0 {
                result = true
            }
        }
        
        return result
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func done() {
        var save = true
        
        let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        alert.view.tintColor = UIColor.redColor()
        
        if !self.validateReps() {
            alert.title = "Reps value is invalid!"
            self.presentViewController(alert, animated: false, completion: nil)
            save = false
        }
        
        if !self.validateWeight() {
            alert.title = "Weight value is invalid!"
            self.presentViewController(alert, animated: false, completion: nil)
            save = false
        }
        
        if save {
            self.exerciseSet.repetitions        = NSNumberFormatter().numberFromString(self.repsText.text)!.unsignedShortValue
            self.exerciseSet.weightKG           = NSNumberFormatter().numberFromString(self.weightText.text)!.floatValue
            self.exerciseSet.weightLB           = self.exerciseSet.weightKG
            self.exerciseSet.repetitionsType    = self.repType[self.repTypePicker.selectedRowInComponent(0)]
            
            var selected = self.restPicker.selectedRowInComponent(0)
            if selected == 0 {
                self.exerciseSet.restIntervalSec = nil
            } else {
                for (key,value) in enumerate(self.restTime) {
                    if key+1 == selected {
                        self.exerciseSet.restIntervalSec = value
                        break
                    }
                }
            }
            
            var append = true
            
            if let index = self.setIndex {
                if self.exercise.sets != nil && self.exercise.sets!.count > index {
                    self.exercise.sets![index] = self.exerciseSet
                    append = false
                }
            }
            
            if append {
                if self.exercise.sets == nil {
                    self.exercise.sets = [WorkoutExerciseSet]()
                }
            
                self.exercise.sets!.append(self.exerciseSet!)
            }
            
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}