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
    
    var hashId:         String?
    var locationFetch:  Bool                = false
    var locations:      [String: String]    = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.locationFetch {
            if let locations = GymDBAPI.locationGetList() {
                for (key,value) in locations {
                    self.locations[key] = value
                }
                self.locationPickerView.reloadAllComponents()
            }
            
            self.locationFetch = true
        }
        
        if self.hashId != nil {
            if let workout = GymDBAPI.workoutLoad(self.hashId!) {
                WorkoutCache.workout = workout
            } else {
                let alert = UIAlertController(title: "Error", message: "Cannot load workout!", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: false, completion: nil)
            }
            
            self.hashId = nil
        }
        
        if ExerciseCache.exerciseCategories == nil {
            ExerciseCache.exerciseCategories = GymDBAPI.exerciseGetList()
        }
        
        self.setViewUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locations.count+1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var result = ""
        
        if row == 0 {
            result = "- Not selected -"
        } else {
            var i = 0
            for (key,value) in self.locations {
                if i++ == row-1 {
                    result = value
                    break
                }
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