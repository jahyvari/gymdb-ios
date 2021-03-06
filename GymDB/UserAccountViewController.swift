//
//  UserAccountViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class UserAccountViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var emailText:           UITextField!
    @IBOutlet weak var firstnameText:       UITextField!
    @IBOutlet weak var lastnameText:        UITextField!
    @IBOutlet weak var timeZonePickerView:  UIPickerView!
    @IBOutlet weak var timeoutSegmented:    UISegmentedControl!
    @IBOutlet weak var unitSegmented:       UISegmentedControl!
    @IBOutlet weak var passwordText:        UITextField!
    @IBOutlet weak var password2Text:       UITextField!
    
    var timezones:  [UInt: String] = [:]
    var user:       User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "Loading data...", message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: false, completion: nil)
        
        let timezones   = GymDBAPI.timeZoneGetList()
        let user        = GymDBAPI.userLoad()
        
        if user != nil {
            self.user       = user
            UserCache.user  = user
        }
        
        if timezones != nil {
            self.timezones = timezones!
            self.timeZonePickerView.reloadAllComponents()
        }
        
        self.setViewUI()
        
        alert.dismissViewControllerAnimated(false, completion: {
            LoginViewController.showLoginViewIfTimedOut(self, sessionIsValid: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.timezones.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var result = ""
        var i = 0
        
        for (key,value) in self.timezones {
            if i++ == row {
                result = value
                break
            }
        }
        
        return result
    }
    
    func setViewUI() {
        if self.user != nil {
            self.emailText.text = self.user!.email
            
            if let firstname = self.user!.firstname {
                self.firstnameText.text = firstname
            }
            
            if let lastname = self.user!.lastname {
                self.lastnameText.text = lastname
            }
            
            for var i = 0; i < self.timeoutSegmented.numberOfSegments; i++ {
                if self.user!.timeout_min == UInt(self.timeoutSegmented.titleForSegmentAtIndex(i)!.toInt()!) {
                    self.timeoutSegmented.selectedSegmentIndex = i
                    break
                }
            }
            
            for var i = 0; i < self.unitSegmented.numberOfSegments; i++ {
                if self.user!.default_unit.rawValue == self.unitSegmented.titleForSegmentAtIndex(i)!.lowercaseString {
                    self.unitSegmented.selectedSegmentIndex = i
                    break
                }
            }
            
            var i = 0
            for (key,value) in self.timezones {
                if key == self.user!.timezoneid {
                    self.timeZonePickerView.selectRow(i, inComponent: 0, animated: false)
                    break
                }
                i++
            }
        }
    }
    
    @IBAction func save() {
        var addAction = true
        let alert = UIAlertController(title: "Saving data...", message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: false, completion: nil)
        
        if (self.user != nil) {
            self.user!.email        = self.emailText.text
            self.user!.firstname    = self.firstnameText.text
            self.user!.lastname     = self.lastnameText.text
            
            var i = 0
            for (key,value) in self.timezones {
                if i++ == self.timeZonePickerView.selectedRowInComponent(0) {
                    self.user!.timezoneid = key
                    break
                }
            }
            
            self.user!.timeout_min  = UInt(self.timeoutSegmented.titleForSegmentAtIndex(self.timeoutSegmented.selectedSegmentIndex)!.toInt()!)
            
            self.user!.default_unit = Unit.fromString(self.unitSegmented.titleForSegmentAtIndex(self.unitSegmented.selectedSegmentIndex)!.lowercaseString)!
            
            var password:   String?
            var password2:  String?
            
            if self.passwordText.text != "" {
                password = self.passwordText.text
            }
            if self.password2Text.text != "" {
                password2 = self.password2Text.text
            }
            
            var apiResponse: GymDBAPIResponse?
            if self.user!.save(&apiResponse, password: password, password2: password2) {
                alert.title = "User account data saved!"
                UserCache.user = self.user
            } else {
                if GymDBAPI.loged {
                    alert.view.tintColor = UIColor.redColor()
                    alert.title = "Error"
                    alert.message = GymDBAPI.apiResponseToString(apiResponse!)
                } else {
                    alert.dismissViewControllerAnimated(false, completion: {
                        LoginViewController.showLoginViewIfTimedOut(self, sessionIsValid: nil)
                    })
                }
            }
        } else {
            alert.view.tintColor = UIColor.redColor()
            alert.title = "Unknown user!"
        }
        
        if addAction {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
    }
}