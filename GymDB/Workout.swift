//
//  Workout.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 22.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class Workout: WorkoutProtocol {
    var hashId:                 String?
    var locationHashId:         String?
    var locationText:           String?
    var trainingProgramHashId:  String?
    var templateHashId:         String?
    var extratext:              String
    var startTime:              String
    var endTime:                String
    var userWeight:             UserWeight?
    var exercises:              [WorkoutExercise]?
    var records:                [WorkoutRecord]?
    
    init(hashId: String?, locationHashId: String?, trainingProgramHashId: String?, templateHashId: String?, extratext: String, startTime: String, endTime: String, userWeight: UserWeight?, exercises: [WorkoutExercise]?, records: [WorkoutRecord]?) {
        self.hashId                 = hashId
        self.locationHashId         = locationHashId
        self.trainingProgramHashId  = trainingProgramHashId
        self.templateHashId         = templateHashId
        self.extratext              = extratext
        self.startTime              = startTime
        self.endTime                = endTime
        self.userWeight             = userWeight
        self.exercises              = exercises
        self.records                = records
    }
    
    required init(data: AnyObject) {
        self.hashId                 = data["hashid"] as? String
        self.locationHashId         = data["locationhashid"] as? String
        self.trainingProgramHashId  = data["training_program_hashid"] as? String
        self.templateHashId         = data["templatehashid"] as? String
        self.extratext              = data["extratext"] as String
        self.startTime              = data["starttime"] as String
        self.endTime                = data["endtime"] as String
        
        var i = 0
        
        if let userWeight = data["user_weight"] as? [String: AnyObject] {
            self.userWeight = UserWeight(data: userWeight)
        }
        
        if let exercises = data["exercises"] as? [AnyObject] {
            for exercise in exercises {
                if i == 0 {
                    self.exercises = [WorkoutExercise]()
                }
                self.exercises?.append(WorkoutExercise(data: exercise))
                i++
            }
        }
        
        if let records = data["records"] as? [AnyObject] {
            i = 0
            for record in records {
                if i == 0 {
                    self.records = [WorkoutRecord]()
                }
                self.records?.append(WorkoutRecord(data: record))
                i++
            }
        }
    }
    
    required init(templateData: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let now = NSDate()
        let plusOneHour = NSDate.dateByAddingTimeInterval(NSDate())(60*60)
        
        self.templateHashId = templateData["hashid"] as? String
        self.extratext      = templateData["extratext"] as String
        self.startTime      = dateFormatter.stringFromDate(now)
        self.endTime        = dateFormatter.stringFromDate(plusOneHour)
        
        var i = 0
        
        if let exercises = templateData["exercises"] as? [AnyObject] {
            for exercise in exercises {
                if i == 0 {
                    self.exercises = [WorkoutExercise]()
                }
                self.exercises?.append(WorkoutExercise(templateData: exercise))
                i++
            }
        }
        
        if let records = templateData["records"] as? [AnyObject] {
            i = 0
            for record in records {
                if i == 0 {
                    self.records = [WorkoutRecord]()
                }
                self.records?.append(WorkoutRecord(templateData: record))
                i++
            }
        }
    }
    
    func save(inout apiResponse: GymDBAPIResponse?) -> Bool {
        var result = false
        
        let json = self.toJSONObject()
        
        GymDBAPI.postRequest("Workout", functionName: "save", data: json)
        
        apiResponse = GymDBAPI.lastAPIResponse!
        
        if (apiResponse!.code == 0) {
            self.hashId = apiResponse!.data as? String
            result = true
        }
        
        return result
    }
    
    func toJSONObject() -> [String : AnyObject] {
        var exercises: [[String: AnyObject]] = []
        if self.exercises != nil {
            for exercise in self.exercises! {
                exercises.append(exercise.toJSONObject())
            }
        }
        
        var records: [[String: AnyObject]] = []
        if self.records != nil {
            for record in self.records! {
                records.append(record.toJSONObject())
            }
        }
        
        var userWeight: [String: AnyObject] = [:]
        if self.userWeight != nil {
            userWeight = self.userWeight!.toJSONObject()
        }
        
        var json: [String: AnyObject] = [
            "extratext":    self.extratext,
            "starttime":    self.startTime,
            "endtime":      self.endTime,
            "user_weight":  userWeight,
            "exercises":    exercises,
            "records":      records
        ]
        
        if let hashId = self.hashId {
            json["hashid"] = hashId
        }
        
        if let locationHashId = self.locationHashId {
            json["locationhashid"] = locationHashId
        }
        
        if let locationText = self.locationText {
            json["locationtext"] = locationText
        }
        
        if let trainingProgramHashId = self.trainingProgramHashId {
            json["training_program_hashid"] = trainingProgramHashId
        }
        
        if let templateHashId = self.templateHashId {
            json["templatehashid"] = templateHashId
        }
        
        if userWeight.count == 0 {
            json.removeValueForKey("user_weight")
        }
        
        if exercises.count == 0 {
            json.removeValueForKey("exercises")
        }
        
        if records.count == 0 {
            json.removeValueForKey("records")
        }
        
        return json
    }
}