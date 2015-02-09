//
//  WorkoutViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 2.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    @IBOutlet weak var showTemplateButton:  UIButton!
    @IBOutlet weak var extratextText:       UITextField!
    @IBOutlet weak var locationPickerView:  UIPickerView!
    @IBOutlet weak var newLocationText:     UITextField!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeDatePicker:   UIDatePicker!
    
    var alert:                  UIAlertController   = UIAlertController(title: "Loading data...", message: nil, preferredStyle: .Alert)
    var canHideAlert:           Bool                = false
    var hashId:                 String?
    var templateHashId:         String?
    var trainingProgramHashId:  String?
    var locations:              [String: String]    = [:]
    var uiInit:                 Bool                = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.uiInit {
            var canHide = true
            self.presentViewController(self.alert, animated: false, completion: nil)
            
            if ExerciseCache.exerciseCategories == nil {
                ExerciseCache.exerciseCategories = GymDBAPI.exerciseGetList()
            }
            
            if let locations = GymDBAPI.locationGetList() {
                for (key,value) in locations {
                    self.locations[key] = value
                }
                self.locationPickerView.reloadAllComponents()
            }
            
            if self.hashId != nil || self.templateHashId != nil {
                var workout: Workout?
                
                if self.hashId != nil {
                    workout = GymDBAPI.workoutLoad(self.hashId!)
                } else {
                    workout = GymDBAPI.workoutLoadFromTemplate(self.templateHashId!)
                }
                
                if workout != nil {
                    WorkoutCache.workout = workout!
                } else {
                    canHide = false
                    
                    self.alert.view.tintColor = UIColor.redColor()
                    self.alert.title = "Cannot load workout!"
                    self.alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
                        self.dismissViewControllerAnimated(false, completion: nil)
                    }))
                }
                
                self.hashId = nil
                self.templateHashId = nil
            } else {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let now = NSDate()
                let plusOneHour = NSDate.dateByAddingTimeInterval(NSDate())(60*60)
                
                WorkoutCache.workout = Workout(hashId: nil, locationHashId: nil, trainingProgramHashId: nil, templateHashId: nil, extratext: "", startTime: dateFormatter.stringFromDate(now), endTime: dateFormatter.stringFromDate(plusOneHour), exercises: nil, records: nil)
            }
            
            WorkoutCache.workout?.trainingProgramHashId = self.trainingProgramHashId
            
            self.setViewUI()
            self.uiInit = true
            
            if canHide {
                self.canHideAlert = true
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.canHideAlert {
            self.canHideAlert = false
            self.alert.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.dataToCache()
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
    
    func dataToCache() {
        if WorkoutCache.workout != nil {
            WorkoutCache.workout!.extratext = self.extratextText.text
            
            let selected = self.locationPickerView.selectedRowInComponent(0)
            if selected == 0 {
                WorkoutCache.workout!.locationHashId = nil
            } else {
                var i = 1
                for (key,value) in self.locations {
                    if i++ == selected {
                        WorkoutCache.workout!.locationHashId = key
                        break
                    }
                }
            }
            
            let locationText = self.newLocationText.text
            if locationText != "" {
                WorkoutCache.workout!.locationText = locationText
            } else {
                WorkoutCache.workout!.locationText = nil
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            WorkoutCache.workout!.startTime = dateFormatter.stringFromDate(self.startTimeDatePicker.date)
            WorkoutCache.workout!.endTime   = dateFormatter.stringFromDate(self.endTimeDatePicker.date)
        }
    }
    
    func setViewUI() {
        if let workout = WorkoutCache.workout {
            self.extratextText.text = workout.extratext
            
            if let locationHashId = workout.locationHashId {
                var i = 1
                
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
            
            if workout.templateHashId != nil {
                self.showTemplateButton.enabled = true
            }
        }
    }
    
    class func saveWorkout(sender: UIViewController) {
        var addAction = true
        let alert = UIAlertController(title: "Saving data...", message: nil, preferredStyle: .Alert)
        sender.presentViewController(alert, animated: false, completion: nil)
        
        if WorkoutCache.workout != nil {
            var apiResponse: GymDBAPIResponse?
            
            if WorkoutCache.workout!.save(&apiResponse) {
                WorkoutCache.refreshList = true
                alert.title = "Workout saved!"
            } else {
                if GymDBAPI.loged {
                    alert.view.tintColor = UIColor.redColor()
                    alert.title = "Error"
                    alert.message = GymDBAPI.apiResponseToString(apiResponse!)
                } else {
                    addAction = false
                    alert.dismissViewControllerAnimated(false, completion: {
                        LoginViewController.showLoginViewIfTimedOut(sender, sessionIsValid: nil)
                    })
                }
            }
        } else {
            alert.view.tintColor = UIColor.redColor()
            alert.title = "Workout cache is empty!"
        }
        
        if addAction {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func save() {
        self.dataToCache()
        WorkoutViewController.saveWorkout(self)
    }
    
    @IBAction func showTemplate() {
        if let workout = WorkoutCache.workout {
            if let templateHashId = workout.templateHashId {
                let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("templateViewController") as TemplateViewController
                
                viewController.hashId = templateHashId
                
                self.presentViewController(viewController, animated: false, completion: nil)
            }
        }
    }
}