//
//  SelectExerciseViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 16.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class SelectExerciseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var exerciseCategoryTable:   UITableView!
    @IBOutlet weak var exerciseTable:           UITableView!
    
    var exerciseId:             UInt?
    var exerciseSet:            WorkoutExerciseSet!
    var selectedExercise:       Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            self.selectedExercise = ExerciseCache.findByExerciseId(self.exerciseId!)
            
            var categoryRow = 0
            var exerciseRow = 0
            var categorySection = 0
            
            // Find row & section for exercise category and exercise
            for category in ExerciseCache.exerciseCategories! {
                if category.category == self.selectedExercise!.exerciseCategory {
                    categoryRow = 0
                    
                    for (musclegroup,exercises) in category.exercises {
                        if musclegroup == self.selectedExercise!.musglegroup {
                            for exercise in exercises {
                                if exercise.id == selectedExercise!.id {
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var result = 1
        
        if tableView.tag == 100 {
            if let categories = ExerciseCache.exerciseCategories {
                result = categories.count
            }
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result: String?
        
        if tableView.tag == 100 {
            if let categories = ExerciseCache.exerciseCategories {
                result = categories[section].category.description
            }
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        
        if let categories = ExerciseCache.exerciseCategories {
            if tableView.tag == 100 {
                result = categories[section].exercises.count
            } else {
                if let selected = self.selectedExercise {
                    for category in categories {
                        if category.category == selected.exerciseCategory {
                            for (musclegroup,exercises) in category.exercises {
                                if musclegroup == selected.musglegroup {
                                    result = exercises.count
                                    break
                                }
                            }
                            break
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellName = "exerciseCategoryCell"
        if tableView.tag == 101 {
            cellName = "exerciseCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as SelectExerciseTableViewCell
        
        var cellText = ""
        
        if let categories = ExerciseCache.exerciseCategories {
            if tableView.tag == 100 {
                var i = 0
                for (key,value) in categories[indexPath.section].exercises {
                    if i++ == indexPath.row {
                        cellText = key.description
                        break
                    }
                }
            } else {
                if let selected = self.selectedExercise {
                    for category in categories {
                        if category.category == selected.exerciseCategory {
                            for (musclegroup,exercises) in category.exercises {
                                if musclegroup == selected.musglegroup {
                                    cellText = exercises[indexPath.row].name
                                    break
                                }
                            }
                            break
                        }
                    }
                }
            }
        }
    
        cell.nameLabel.text = cellText
        
        return cell
    }

    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
