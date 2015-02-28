//
//  WorkoutExercisesViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 6.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutExercisesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var editButton:          UIButton!
    @IBOutlet weak var exercisesTableView:  UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.exercisesTableView.reloadData()
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
        var exercise = WorkoutCache.workout!.exercises![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutExercisesCell", forIndexPath: indexPath) as WorkoutExercisesTableViewCell
        
        let index = indexPath.row+1
        
        cell.noLabel.text           = String("\(index).")
        cell.extratextLabel.text    = exercise.extratext
        cell.setsLabel.text         = exercise.sets != nil ? String(exercise.sets!.count) : "0"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let duplicateAction = UITableViewRowAction(style: .Default, title: "Duplicate", handler: {(action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let source = WorkoutCache.workout!.exercises![indexPath.row]
            
            var sets: [WorkoutExerciseSet]?
            if source.sets != nil && source.sets!.count > 0 {
                var i = 0
                for set in source.sets! {
                    if i == 0 {
                        sets = [WorkoutExerciseSet]()
                    }
                    
                    sets!.append(WorkoutExerciseSet(exerciseId: set.exerciseId, repetitions: set.repetitions, weightKG: set.weightKG, weightLB: set.weightLB, repetitionsType: set.repetitionsType, barbellType: set.barbellType, restIntervalSec: set.restIntervalSec))
                    
                    i++
                }
            }
            
            let exercise = WorkoutExercise(unit: source.unit, extratext: source.extratext, special: source.special, gearBelt: source.gearBelt, gearKneeWraps: source.gearKneeWraps, gearShirt: source.gearShirt, gearSuit: source.gearSuit, gearWristStraps: source.gearWristStraps, gearWristWraps: source.gearWristWraps, sets: sets)
    
            WorkoutCache.workout!.exercises!.insert(exercise, atIndex: indexPath.row+1)
            
            tableView.reloadData()
        })
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            WorkoutCache.workout!.exercises!.removeAtIndex(indexPath.row)
            
            if WorkoutCache.workout!.exercises!.count == 0 {
                WorkoutCache.workout!.exercises = nil
            }
            
            tableView.reloadData()
        })
        
        duplicateAction.backgroundColor = UIColor.greenColor()
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction,duplicateAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let exercise = WorkoutCache.workout!.exercises![sourceIndexPath.row]
        
        WorkoutCache.workout!.exercises!.removeAtIndex(sourceIndexPath.row)
        WorkoutCache.workout!.exercises!.insert(exercise, atIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.showWorkoutExercise(indexPath.row)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func showWorkoutExercise(exerciseIndex: Int?) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("workoutExerciseViewController") as WorkoutExerciseViewController
        
        viewController.exerciseIndex = exerciseIndex
        
        self.presentViewController(viewController, animated: false, completion: nil)
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func save() {
        WorkoutViewController.saveWorkout(self)
    }
    
    @IBAction func edit() {
        if self.exercisesTableView.editing {
            self.editButton.setTitle("Edit", forState: .Normal)
            
            self.exercisesTableView.setEditing(false, animated: false)
            self.exercisesTableView.reloadData()
        } else {
            self.editButton.setTitle("Done", forState: .Normal)
            
            self.exercisesTableView.setEditing(true, animated: false)
        }
    }
    
    @IBAction func addExercise() {
        self.showWorkoutExercise(nil)
    }
}