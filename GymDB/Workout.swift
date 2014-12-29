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
    var trainingProgramHashId:  String?
    var templateHashId:         String?
    var extratext:              String
    var startTime:              String
    var endTime:                String
    var exercises:              [WorkoutExercise]?
    var records:                [WorkoutRecord]?
    
    init(hashId: String?, locationHashId: String?, trainingProgramHashId: String?, templateHashId: String?, extratext: String, startTime: String, endTime: String, exercises: [WorkoutExercise]?, records: [WorkoutRecord]?) {
        self.hashId                 = hashId
        self.locationHashId         = locationHashId
        self.trainingProgramHashId  = trainingProgramHashId
        self.templateHashId         = templateHashId
        self.extratext              = extratext
        self.startTime              = startTime
        self.endTime                = endTime
        self.exercises              = exercises
        self.records                = records
    }
    
    required init(data: AnyObject) {
        self.hashId                 = data["hashid"] as? String
        self.locationHashId         = data["locationhashid"] as? String
        self.trainingProgramHashId  = data["training_program_hashid"] as? String
        self.extratext              = data["extratext"] as String
        self.startTime              = data["starttime"] as String
        self.endTime                = data["endtime"] as String
        
        if let exercises = data["exercises"] as? [AnyObject] {
            for exercise in exercises {
                self.exercises?.append(WorkoutExercise(data: exercise))
            }
        }
        
        if let records = data["records"] as? [AnyObject] {
            for record in records {
                self.records?.append(WorkoutRecord(data: record))
            }
        }
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
        
        var json: [String: AnyObject] = [
            "extratext":    self.extratext,
            "starttime":    self.startTime,
            "endtime":      self.endTime,
            "exercises":    exercises,
            "records":      records
        ]
        
        if let hashId = self.hashId {
            json["hashid"] = hashId
        }
        
        if let locationHashId = self.locationHashId {
            json["locationhashid"] = locationHashId
        }
        
        if let trainingProgramHashId = self.trainingProgramHashId {
            json["training_program_hashid"] = trainingProgramHashId
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