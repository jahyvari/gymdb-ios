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
        
        var timezones   = GymDBAPI.timeZoneGetList()
        var user        = GymDBAPI.userLoad()
        
        alert.dismissViewControllerAnimated(false, completion: {
            if user != nil {
                self.user = user
                
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
            }
            
            if timezones != nil {
                self.timezones = timezones!
                self.timeZonePickerView.reloadAllComponents()
                
                if self.user != nil {
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
    
    @IBAction func save() {
    
    }
}