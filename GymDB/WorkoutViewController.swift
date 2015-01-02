//
//  WorkoutViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 2.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}