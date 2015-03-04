//
//  TemplateViewController.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 2.2.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import UIKit

class TemplateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var navBar:          UINavigationBar!
    @IBOutlet weak var closeButton:     UIBarButtonItem!
    @IBOutlet weak var recordTextView:  UITextView!
    @IBOutlet weak var exerciseNoLabel: UILabel!
    @IBOutlet weak var specialLabel:    UILabel!
    @IBOutlet weak var prevButton:      UIButton!
    @IBOutlet weak var nextButton:      UIButton!
    @IBOutlet weak var setsTableView:   UITableView!
    
    var alert:          UIAlertController   = UIAlertController(title: "Loading data...", message: nil, preferredStyle: .Alert)
    var canHideAlert:   Bool                = false
    var exerciseIndex:  Int                 = 0
    var hashId:         String?
    var template:       Template?
    var uiInit:         Bool                = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setsTableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.recordTextView.layer.borderColor   = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        self.recordTextView.layer.borderWidth   = 0.5
        self.recordTextView.layer.cornerRadius  = 8
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.uiInit {
            self.presentViewController(self.alert, animated: false, completion: nil)
            
            if self.hashId != nil {
                self.template = GymDBAPI.templateLoad(self.hashId!)
            }
            
            if ExerciseCache.exerciseCategories == nil {
                ExerciseCache.exerciseCategories = GymDBAPI.exerciseGetList()
            }
            
            if self.template == nil {
                self.alert.view.tintColor = UIColor.redColor()
                self.alert.title = "Cannot load template!"
                self.alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) in
                    self.dismissViewControllerAnimated(false, completion: nil)
                }))
            } else {
                self.canHideAlert = true
                self.setViewUI()
            }
            
            self.uiInit = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.canHideAlert {
            self.canHideAlert = false
            self.alert.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        
        if let sets = self.getCurrentSets() {
            result = sets.count
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("templateSetCell", forIndexPath: indexPath) as TemplateExerciseSetTableViewCell
        
        if let sets = self.getCurrentSets() {
            let set = sets[indexPath.row]
            
            var exerciseName = ""
            var musclegroupName = ""
            if let exercise = ExerciseCache.findByExerciseId(set.exerciseId) {
                exerciseName = exercise.name
                if let barbellType = set.barbellType {
                    exerciseName = exerciseName + " (" + barbellType.description + ")"
                }
                
                musclegroupName = exercise.musglegroup.description+" - "+exercise.exerciseCategory.description
            }
            
            var reps = String(set.repetitions)
            if let repetitionsEnd = set.repetitionsEnd {
                reps += " - "+String(repetitionsEnd)
            }
            
            let unit = self.getCurrentExercise()!.unit
            var weight = set.weightKG
            if unit == .LB {
                weight = set.weightLB
            }
            
            var rest = ""
            if let restIntervalSec = set.restIntervalSec {
                rest = "\(restIntervalSec) sec"
            }
            
            var oneRepMax = ""
            if let oneRepMaxPercent = set.oneRepMaxPercent {
                oneRepMax = "(" +  NSString(format: "%.2f", oneRepMaxPercent) + " %)"
                weight = weight * (oneRepMaxPercent/100)
            }
            
            cell.setNoLabel.text            = "\(indexPath.row+1)."
            cell.musclegroupNameLabel.text  = musclegroupName
            cell.exerciseNameLabel.text     = exerciseName
            cell.repsLabel.text             = reps
            cell.weightLabel.text           = NSString(format: "%.2f", weight)+" "+unit.description
            cell.restLabel.text             = rest
            cell.repTypeLabel.text          = set.repetitionsType.description
            cell.oneRepMaxPercentLabel.text = oneRepMax
        }
        
        return cell
    }
    
    func getCurrentSets() -> [TemplateExerciseSet]? {
        var result: [TemplateExerciseSet]?
        
        if let exercise = self.getCurrentExercise() {
            result = exercise.sets
        }
        
        return result
    }
    
    func getCurrentExercise() -> TemplateExercise? {
        var result: TemplateExercise?
        
        if let exercises = self.getExercises() {
            if self.exerciseIndex >= 0 && exercises.count > self.exerciseIndex {
                result = exercises[self.exerciseIndex]
            }
        }
        
        return result
    }
    
    func getExercises() -> [TemplateExercise]? {
        var result: [TemplateExercise]?
        
        if let template = self.template {
            result = template.exercises
        }
        
        return result
    }
    
    func setExerciseNo() {
        var specialText     = ""
        var extratextText   = ""
        var setNo           = ""
        
        if let exercise = self.getCurrentExercise() {
            if let extratext = exercise.extratext {
                extratextText = extratext
            }
            
            if let special = exercise.special {
                specialText = special.description
            }
        }
        
        if let exercises = self.getExercises() {
            setNo = "\(self.exerciseIndex+1) / \(exercises.count)"
            if extratextText != "" {
                setNo = setNo + " - \(extratextText)"
            }
        }
        
        self.specialLabel.text      = specialText
        self.exerciseNoLabel.text   = setNo
    }
    
    func setViewUI() {
        if let template = self.template {
            self.navBar.topItem?.title  = template.extratext
            
            if let records = template.records {
                self.recordTextView.text = records[0].record
            }
            
            if let exercises = self.getExercises() {
                if exercises.count > 1 {
                    self.nextButton.enabled = true
                }
            }
            
            self.setExerciseNo()
            self.setsTableView.reloadData()
        }
    }
    
    @IBAction func prev() {
        if self.exerciseIndex > 0 {
            self.exerciseIndex--
            
            self.nextButton.enabled = true
            if self.exerciseIndex == 0 {
                self.prevButton.enabled = false
            }
            
            self.setExerciseNo()
            self.setsTableView.reloadData()
        }
    }
    
    @IBAction func next() {
        if let exercises = self.getExercises() {
            if (exercises.count-1) > self.exerciseIndex {
                self.exerciseIndex++
                
                self.prevButton.enabled = true
                if (self.exerciseIndex+1) == exercises.count {
                    self.nextButton.enabled = false
                }
                
                self.setExerciseNo()
                self.setsTableView.reloadData()
            }
        }
    }
    
    @IBAction func close() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
