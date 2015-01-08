//
//  WorkoutViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 2.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    @IBOutlet weak var extratextText:       UITextField!
    @IBOutlet weak var locationPickerView:  UIPickerView!
    @IBOutlet weak var newLocationText:     UITextField!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeDatePicker:   UIDatePicker!
    
    var hashId: String?
    
    private struct _data {
        static var locationFetch:   Bool                = false
        static var locations:       [String: String]    = ["": "Select..."]
    }
    
    var locationFetch: Bool {
        get {
            return _data.locationFetch
        }
        set {
            _data.locationFetch = newValue
        }
    }
    
    var locations: [String: String] {
        get {
            return _data.locations
        }
        set {
            _data.locations = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationFetch = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.locationFetch || self.hashId != nil {
            if !self.locationFetch {
                self.locationFetch = true
                
                if let locations = GymDBAPI.locationGetList() {
                    for (key,value) in locations {
                        self.locations[key] = value
                    }
                    self.locationPickerView.reloadAllComponents()
                }
            }
            
            if self.hashId != nil {
                if let workout = GymDBAPI.workoutLoad(self.hashId!) {
                    WorkoutCache.workout = workout
                } else {
                    let alert = UIAlertController(title: nil, message: "Cannot load workout", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    
                    self.presentViewController(alert, animated: false, completion: nil)
                }
                
                self.hashId = nil
            }
            
            self.setViewUI()
        } else {
            self.setViewUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locations.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var result = ""
        var i = 0
        
        for (key,value) in self.locations {
            if i++ == row {
                result = value
                break
            }
        }
        
        return result
    }
    
    func setViewUI() {
        if let workout = WorkoutCache.workout {
            self.extratextText.text = workout.extratext
            
            if let locationHashId = workout.locationHashId {
                var i = 0
                
                for (key,value) in self.locations {
                    if key == locationHashId {
                        self.locationPickerView.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                    i++
                }
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            self.startTimeDatePicker.setDate(dateFormatter.dateFromString(workout.startTime)!, animated: false)
            self.endTimeDatePicker.setDate(dateFormatter.dateFromString(workout.endTime)!, animated: false)
        }
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}