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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recordTextView.layer.borderColor   = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        self.recordTextView.layer.borderWidth   = 0.5
        self.recordTextView.layer.cornerRadius  = 8
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let workout = WorkoutCache.workout {
            if let records = workout.records {
                if records.count > 0 {
                    self.recordTextView.text = records[0].record
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
