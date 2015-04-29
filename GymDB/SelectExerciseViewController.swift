//
//  SelectExerciseViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 16.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class SelectExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var selectBarButton:         UIBarButtonItem!
    @IBOutlet weak var barbellTypePicker:       UIPickerView!
    @IBOutlet weak var exerciseCategoryTable:   UITableView!
    @IBOutlet weak var exerciseTable:           UITableView!
    
    var barbellType:            BarbellType?
    var barbellTypes:           [BarbellType] = BarbellType.allValues
    var currentExercises:       [Exercise]?
    var exerciseId:             UInt?
    var exerciseSet:            WorkoutExerciseSet!
    var selectedCategory:       ExerciseCategories?
    var selectedExerciseId:     UInt?
    var selectedMusclegroup:    Musclegroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exerciseCategoryTable.tableFooterView = UIView(frame: CGRectZero)
        self.exerciseTable.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.exerciseId == nil {
            self.exerciseId = ExerciseCache.getFirstExercise()?.id
        }
        
        if self.exerciseId == nil || ExerciseCache.findByExerciseId(self.exerciseId!) == nil {
            let alert = UIAlertController(title: "Cannot load exercise cache!", message: nil, preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
                self.dismissViewControllerAnimated(false, completion: nil)
            }))
            alert.view.tintColor = UIColor.redColor()
            
            self.presentViewController(alert, animated: false, completion: nil)
        } else {
            var foundExercise = ExerciseCache.findByExerciseId(self.exerciseId!)
            
            self.selectedCategory       = foundExercise!.exerciseCategory
            self.selectedExerciseId     = foundExercise!.id
            self.selectedMusclegroup    = foundExercise!.musglegroup
            
            var categoryRow     = 0
            var exerciseRow     = 0
            var categorySection = 0
            
            // Find row & section for exercise category and exercise
            for category in ExerciseCache.sortedExerciseCategories! {
                if category.category == self.selectedCategory! {
                    categoryRow = 0
                    for musclegroup in category.sortedMusclegroups {
                        if musclegroup == self.selectedMusclegroup! {
                            self.currentExercises = category.sortedExercisesByMusclegroup(musclegroup)!
                            for exercise in category.sortedExercisesByMusclegroup(musclegroup)! {
                                if exercise.id == self.selectedExerciseId! {
                                    break
                                }
                                exerciseRow++
                            }
                            break
                        }
                        categoryRow++
                    }
                    break
                }
                categorySection++
            }
            
            self.exerciseCategoryTable.selectRowAtIndexPath(NSIndexPath(forRow: categoryRow, inSection: categorySection), animated: false, scrollPosition: .Middle)
            
            self.exerciseTable.reloadData()
            self.exerciseTable.selectRowAtIndexPath(NSIndexPath(forRow: exerciseRow, inSection: 0), animated: false, scrollPosition: .Middle)
            
            if self.selectedCategory == .Barbell && self.barbellType != nil {
                if let index = find(self.barbellTypes, self.barbellType!) {
                    self.barbellTypePicker.selectRow(index+1, inComponent: 0, animated: false)
                }
            } else if self.selectedCategory != .Barbell {
                self.barbellTypePicker.userInteractionEnabled = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var result = 1
        
        if tableView.tag == 100 {
            if let categories = ExerciseCache.sortedExerciseCategories {
                result = categories.count
            }
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result: String?
        
        if tableView.tag == 100 {
            if let categories = ExerciseCache.sortedExerciseCategories {
                result = categories[section].category.description
            }
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        
        if tableView.tag == 100 {
            if let categories = ExerciseCache.sortedExerciseCategories {
                result = categories[section].sortedMusclegroups.count
            }
        } else {
            if let currentExercises = self.currentExercises {
                result = currentExercises.count
            }
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellName = "exerciseCategoryCell"
        if tableView.tag == 101 {
            cellName = "exerciseCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as! SelectExerciseTableViewCell
        
        var cellText = ""
        
        if tableView.tag == 100 {
            if let categories = ExerciseCache.sortedExerciseCategories {
                var i = 0
                for musclegroup in categories[indexPath.section].sortedMusclegroups {
                    if i++ == indexPath.row {
                        cellText = musclegroup.description
                        break
                    }
                }
            }
        } else {
            if let currentExercises = self.currentExercises {
                cellText = currentExercises[indexPath.row].name
            }
        }
    
        cell.nameLabel.text = cellText
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 100 {
            if let categories = ExerciseCache.sortedExerciseCategories {
                let category = categories[indexPath.section]
                
                self.selectedCategory = category.category
                
                var i = 0
                for musclegroup in category.sortedMusclegroups {
                    if i++ == indexPath.row {
                        self.currentExercises = category.sortedExercisesByMusclegroup(musclegroup)!
                        self.selectedMusclegroup = musclegroup
                        break
                    }
                }
                
                self.selectedExerciseId = nil
                self.selectBarButton.enabled = false
            
                if self.selectedCategory == .Barbell {
                    self.barbellTypePicker.userInteractionEnabled = true
                } else {
                    self.barbellTypePicker.selectRow(0, inComponent: 0, animated: false)
                    self.barbellTypePicker.userInteractionEnabled = false
                }
                
                self.exerciseTable.reloadData()
            }
        } else {
            if let currentExercises = self.currentExercises {
                self.selectBarButton.enabled = true
                self.selectedExerciseId = currentExercises[indexPath.row].id
            }
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.barbellTypes.count+1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var result = ""
        
        if row == 0 {
            result = "- Not selected -"
        } else {
            result = self.barbellTypes[row-1].description
        }
        
        return result
    }
    
    @IBAction func select() {
        if let selectedExerciseId = self.selectedExerciseId {
            self.exerciseSet.exerciseId = selectedExerciseId
            self.exerciseSet.barbellType = nil
            
            if self.selectedCategory == .Barbell {
                let selected = self.barbellTypePicker.selectedRowInComponent(0)
                if selected > 0 {
                    self.exerciseSet.barbellType = self.barbellTypes[selected-1]
                }
            }
            
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}