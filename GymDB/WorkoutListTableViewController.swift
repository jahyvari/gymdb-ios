//
//  WorkoutListTableViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 20.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutListTableViewController: UITableViewController {
    var searchResult:   [WorkoutSearchResponse] = [WorkoutSearchResponse]()
    var uiInit:         Bool                    = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.uiInit || WorkoutCache.refreshList {
            let alert = UIAlertController(title: "Fetching data...", message: nil, preferredStyle: .Alert)
            self.presentViewController(alert, animated: false, completion: nil)
            
            let result = GymDBAPI.workoutSearch(nil, endDate: nil, pos: 0, count: 30)
            
            if result != nil {
                self.searchResult = result!
            } else {
                self.searchResult = [WorkoutSearchResponse]()
            }
            
            self.tableView.reloadData()
            
            self.uiInit = true
            WorkoutCache.refreshList = false
            
            alert.dismissViewControllerAnimated(false, completion: {
                LoginViewController.showLoginViewIfTimedOut(self, sessionIsValid: nil)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = self.searchResult.count
        
        self.navigationItem.rightBarButtonItem?.enabled = result > 0 ? true : false
        
        return result
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let alert = UIAlertController(title: "Deleting in...", message: nil, preferredStyle: .Alert)
            self.presentViewController(alert, animated: false, completion: nil)
            
            let result = GymDBAPI.workoutDelete(self.searchResult[indexPath.row].hashId)
            
            if result {
                alert.dismissViewControllerAnimated(false, completion: {
                    self.searchResult.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                })
            } else {
                alert.view.tintColor = UIColor.redColor()
                alert.title = "Delete failed!"
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            }
        })
        
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutListCell", forIndexPath: indexPath) as WorkoutListTableViewCell
        
        cell.extratextLabel.text = self.searchResult[indexPath.row].extratext
        
        let startTime = self.searchResult[indexPath.row].startTime
        cell.dateLabel.text = startTime.substringToIndex(advance(startTime.startIndex, 10))
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWorkoutViewController" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let hashId = self.searchResult[indexPath.row].hashId
                
                let tabBarController = segue.destinationViewController as UITabBarController
                (tabBarController.viewControllers![0] as WorkoutViewController).hashId = hashId
            }
        }
    }
}