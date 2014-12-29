//
//  LoginViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailText:       UITextField!
    @IBOutlet weak var passwordText:    UITextField!
    @IBOutlet weak var errorLabel:      UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.emailText.text     = ""
        self.passwordText.text  = ""
        
        let email = NSUserDefaults.standardUserDefaults().valueForKey(GymDBAPI.defaultEmailKey) as? String
        let password = NSUserDefaults.standardUserDefaults().valueForKey(GymDBAPI.defaultPasswordKey) as? String
        
        if email != nil && password != nil {
            self.doLogin(email!, password: password!, showError: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doLogin(email: String, password: String, showError: Bool) {
        self.errorLabel.hidden = true
        
        let alert = UIAlertController(title: "Logging in...", message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: false, completion: nil)
        
        let login = GymDBAPI.doLogin(email, password: password)
        
        alert.dismissViewControllerAnimated(false, completion: {
            if (login) {
                self.performSegueWithIdentifier("showMasterViewController", sender: self)
            } else if showError {
                self.errorLabel.text = GymDBAPI.lastAPIResponse!.text
                self.errorLabel.hidden = false
            }
        })
    }
    
    @IBAction func login() {
        self.doLogin(self.emailText.text, password: self.passwordText.text, showError: true)
    }
}