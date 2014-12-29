//
//  MasterViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 22.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout() {
        let alert = UIAlertController(title: "Logging out...", message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: false, completion: nil)
        
        GymDBAPI.doLogout()
        
        alert.dismissViewControllerAnimated(false, completion: {
            self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
}