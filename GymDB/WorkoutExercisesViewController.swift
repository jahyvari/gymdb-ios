//
//  WorkoutExercisesViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 6.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutExercisesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var editBarButton:       UIBarButtonItem!
    @IBOutlet weak var exercisesTableView:  UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        
        if let workout = WorkoutCache.workout {
            if let exercises = workout.exercises {
                result = exercises.count
                
                if result > 1 {
                    self.editBarButton.enabled = true
                } else {
                    self.editBarButton.enabled = false
                }
            }
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var exercise = WorkoutCache.workout!.exercises![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutExercisesCell", forIndexPath: indexPath) as WorkoutExercisesTableViewCell
        
        let index = indexPath.row+1
        
        cell.noLabel.text           = String("\(index).")
        cell.extratextLabel.text    = exercise.extratext
        cell.setsLabel.text         = exercise.sets != nil ? String(exercise.sets!.count) : "0"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.canEditTable()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            WorkoutCache.workout!.exercises!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        })
        
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.canEditTable()
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let exercise = WorkoutCache.workout!.exercises![sourceIndexPath.row]
        
        WorkoutCache.workout!.exercises!.removeAtIndex(sourceIndexPath.row)
        WorkoutCache.workout!.exercises!.insert(exercise, atIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("workoutExerciseViewController") as WorkoutExerciseViewController
        
        self.presentViewController(viewController, animated: false, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func canEditTable() -> Bool {
        var result = false
        
        if let workout = WorkoutCache.workout {
            if let exercises = workout.exercises {
                if exercises.count > 1 {
                    result = true
                }
            }
        }
        
        return result
    }
        
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func edit() {
        if self.exercisesTableView.editing {
            self.editBarButton.title = "Edit"
            
            self.exercisesTableView.setEditing(false, animated: false)
            self.exercisesTableView.reloadData()
        } else {
            self.editBarButton.title = "Done"
            
            self.exercisesTableView.setEditing(true, animated: false)
        }
    }
}