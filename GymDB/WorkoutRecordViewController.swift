//
//  WorkoutRecordViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 5.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutRecordViewController: UIViewController {
    @IBOutlet weak var recordTextView: UITextView!
    
    var uiInit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recordTextView.layer.borderColor   = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        self.recordTextView.layer.borderWidth   = 0.5
        self.recordTextView.layer.cornerRadius  = 8
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set UI
        if !self.uiInit {
            if let workout = WorkoutCache.workout {
                if let records = workout.records {
                    if records.count > 0 {
                        self.recordTextView.text = records[0].record
                    }
                }
            }
            self.uiInit = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.dataToCache()
    }
    
    func dataToCache() {
        if WorkoutCache.workout != nil {
            let recordText = self.recordTextView.text
            if recordText != "" {
                let record = WorkoutRecord(record: recordText)
                
                if WorkoutCache.workout!.records == nil {
                    WorkoutCache.workout!.records = [WorkoutRecord](count: 1, repeatedValue: record)
                } else {
                    WorkoutCache.workout!.records![0] = record
                }
            } else {
                WorkoutCache.workout!.records = nil
            }
        }
    }
}
