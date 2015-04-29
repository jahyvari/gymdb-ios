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
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // For test use only!
        var hashId = ""
        
        if hashId != "" && segue.identifier == "showWorkoutViewController" {
            let tabBarController = segue.destinationViewController as! UITabBarController
            (tabBarController.viewControllers![0] as! WorkoutViewController).hashId = hashId
        }
    }
    
    @IBAction func logout() {
        let alert = UIAlertController(title: "Logging out...", message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: false, completion: nil)
        
        GymDBAPI.doLogout()
        UserCache.user = nil
        
        alert.dismissViewControllerAnimated(false, completion: {
            self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
}