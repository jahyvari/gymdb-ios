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
    
    var modalPresentation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.emailText.text     = ""
        self.passwordText.text  = ""
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
        if login {
            UserCache.user = GymDBAPI.userLoad()
        }
        
        alert.dismissViewControllerAnimated(false, completion: {
            if login {
                if self.modalPresentation {
                    self.modalPresentation = false
                    self.dismissViewControllerAnimated(false, completion: nil)
                } else {
                    self.performSegueWithIdentifier("showMasterViewController", sender: self)
                }
            } else if showError {
                self.errorLabel.text = GymDBAPI.lastAPIResponse!.text
                self.errorLabel.hidden = false
            }
        })
    }
    
    class func showLoginViewIfTimedOut(sender: UIViewController, sessionIsValid: (() -> Void)?) {
        if !GymDBAPI.loged {
            let view = sender.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as LoginViewController
            view.modalPresentation = true
            sender.presentViewController(view, animated: false, completion: nil)
        } else if let sesValid = sessionIsValid {
            sesValid()
        }
    }
    
    @IBAction func login() {
        self.doLogin(self.emailText.text, password: self.passwordText.text, showError: true)
    }
}