//
//  TrainingCalendarTableViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 23.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class TrainingCalendarTableViewController: UITableViewController {
    var searchResult: [TrainingProgramScheduleResponse] = [TrainingProgramScheduleResponse]()
    
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
                self.searchResult = result!
            } else {
                self.searchResult = [TrainingProgramScheduleResponse]()
            }
            
            self.tableView.reloadData()
            
            // Select current date
            if self.searchResult.count > 0 {
                let now = dateFormatter.stringFromDate(NSDate())
                
                for (key,value) in enumerate(self.searchResult) {
                    var scrollred = false
                    if value.workoutDate == now {
                        let indexPath = NSIndexPath(forRow: key, inSection: 0)
                        
                        if !scrollred {
                            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
                            scrollred = true
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("trainingCalendarCell", forIndexPath: indexPath) as TrainingCalendarTableViewCell

        cell.trainingProgramLabel.text  = self.searchResult[indexPath.row].programName
        cell.templateLabel.text         = self.searchResult[indexPath.row].templateExtratext
        cell.workoutDateLabel.text      = self.searchResult[indexPath.row].workoutDate
        
        return cell
    }
}