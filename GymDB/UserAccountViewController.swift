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
    
    var array: [String] = ["test1","test2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.array.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.array[row]
    }
    
    @IBAction func save() {
    
    }
}
