//
//  TrainingCalendarTableViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 23.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class TrainingCalendarTableViewController: UITableViewController {
    var searchResultComing: [TrainingProgramScheduleResponse] = [TrainingProgramScheduleResponse]()
    var searchResultOld:    [TrainingProgramScheduleResponse] = [TrainingProgramScheduleResponse]()
    var searchResultToday:  [TrainingProgramScheduleResponse] = [TrainingProgramScheduleResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "Fetching data...", message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: false, completion: nil)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let minus30Days = NSDate.dateByAddingTimeInterval(NSDate())(-60*60*24*30)
        let plus30Days  = NSDate.dateByAddingTimeInterval(NSDate())(60*60*24*30)
        
        let result = GymDBAPI.trainingProgramSchedule(dateFormatter.stringFromDate(minus30Days), endDate: dateFormatter.stringFromDate(plus30Days), pos: nil, count: nil)
        
        alert.dismissViewControllerAnimated(false, completion: {
            if result != nil {
                let now = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
                
                for value in result! {
                    let compare = now.compare(dateFormatter.dateFromString(value.workoutDate)!)
                    if compare == NSComparisonResult.OrderedAscending {
                        self.searchResultComing.append(value)
                    }
                    else if compare == NSComparisonResult.OrderedDescending {
                        self.searchResultOld.append(value)
                    }
                    else if compare == NSComparisonResult.OrderedSame {
                        self.searchResultToday.append(value)
                    }
                }
            } else {
                self.searchResultOld    = [TrainingProgramScheduleResponse]()
                self.searchResultToday  = [TrainingProgramScheduleResponse]()
                self.searchResultComing = [TrainingProgramScheduleResponse]()
            }
            
            self.tableView.reloadData()
            
            // Select current date
            if self.searchResultToday.count > 0 {
                let now = dateFormatter.stringFromDate(NSDate())
                
                for (key,value) in enumerate(self.searchResultToday) {
                    var scrolled = false
                    if value.workoutDate == now {
                        let indexPath = NSIndexPath(forRow: key, inSection: 1)
                        
                        if !scrolled {
                            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
                            scrolled = true
                        }
                        
                        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as TrainingCalendarTableViewCell
                        cell.backgroundColor = UIColor.colorWithAlphaComponent(UIColor.grayColor())(0.1)
                        cell.todayLabel.hidden = false
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result: String?
        
        if section == 0 {
            result = "Previous workouts"
        } else if section == 1 {
            result = "Today's workouts"
        } else {
            result = "Coming workouts"
        }
        
        return result
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        
        if section == 0 {
            result = self.searchResultOld.count
        } else if section == 1 {
            result = self.searchResultToday.count
        } else {
            result = self.searchResultComing.count
        }
        
        return result
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("trainingCalendarCell", forIndexPath: indexPath) as TrainingCalendarTableViewCell
        let resultRow = self.getResultRow(indexPath)
        
        cell.trainingProgramLabel.text  = resultRow.programName
        cell.templateLabel.text         = resultRow.templateExtratext
        cell.workoutDateLabel.text      = resultRow.workoutDate
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Start workout", style: .Default, handler: {(action: UIAlertAction!) in
            let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("workoutTabBarController") as UITabBarController
            let viewController = tabBarController.viewControllers![0] as WorkoutViewController
            let resultRow = self.getResultRow(indexPath)
            
            viewController.templateHashId           = resultRow.templateHashId
            viewController.trainingProgramHashId    = resultRow.hashId
            
            self.presentViewController(tabBarController, animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: false, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func getResultRow(indexPath: NSIndexPath) -> TrainingProgramScheduleResponse {
        if indexPath.section == 0 {
            return self.searchResultOld[indexPath.row]
        } else if indexPath.section == 1 {
            return self.searchResultToday[indexPath.row]
        } else {
            return self.searchResultComing[indexPath.row]
        }
    }
}