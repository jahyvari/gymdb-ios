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
    
    var isEditing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutExercisesCell", forIndexPath: indexPath) as WorkoutExercisesTableViewCell
        
        let index = indexPath.row+1
        
        cell.noLabel.text           = String("\(index).")
        cell.extratextLabel.text    = ""
        cell.setsLabel.text         = "0"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            // FIXME
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            println("Delete row!")
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
        
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func edit() {
        if self.isEditing {
            self.isEditing = false

            self.editBarButton.title = "Edit"
            
            self.exercisesTableView.setEditing(false, animated: false)
            self.exercisesTableView.reloadData()
        } else {
            self.isEditing = true
            
            self.editBarButton.title = "Commit"
            
            self.exercisesTableView.setEditing(true, animated: false)
        }
    }
}