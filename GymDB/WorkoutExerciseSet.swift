//
//  WorkoutExerciseSet.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 22.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class WorkoutExerciseSet: WorkoutProtocol {
    var exerciseId:         UInt
    var repetitions:        UInt16
    var weightKG:           Float
    var weightLB:           Float
    var repetitionsType:    RepetionsType
    var barbellType:        BarbellType?
    var restIntervalSec:    UInt16?
    
    init(exerciseId: UInt, repetitions: UInt16, weightKG: Float, weightLB: Float, repetitionsType: RepetionsType, barbellType: BarbellType?, restIntervalSec: UInt16?) {
        self.exerciseId         = exerciseId
        self.repetitions        = repetitions
        self.weightKG           = weightKG
        self.weightLB           = weightLB
        self.repetitionsType    = repetitionsType
        self.barbellType        = barbellType
        self.restIntervalSec    = restIntervalSec
    }
    
    required init(data: AnyObject) {
        self.exerciseId         = UInt((data["exerciseid"] as String).toInt()!)
        self.repetitions        = UInt16((data["repetitions"] as String).toInt()!)
        self.weightKG           = NSNumberFormatter().numberFromString(data["weight_kg"] as String)!.floatValue
        self.weightLB           = NSNumberFormatter().numberFromString(data["weight_lb"] as String)!.floatValue
        
        if let repetitionsType = RepetionsType.fromString(data["repetitions_type"] as String) {
            self.repetitionsType = repetitionsType
        } else {
            self.repetitionsType = .Normal
        }
        
        if let barbellType = data["barbell_type"] as? String {
           self.barbellType = BarbellType.fromString(barbellType)
        }
        
        if let restIntervalSec = data["rest_interval_sec"] as? String {
            self.restIntervalSec = UInt16(restIntervalSec.toInt()!)
        }
    }
    
    func save(inout apiResponse: GymDBAPIResponse?) -> Bool {
        return false
    }
    
    func toJSONObject() -> [String: AnyObject] {
        var json: [String: AnyObject] = [
            "exerciseid":           String(self.exerciseId),
            "repetitions":          String(self.repetitions),
            "weight_kg":            NSString(format: "%.2f", self.weightKG),
            "weight_lb":            NSString(format: "%.2f", self.weightLB),
            "repetitions_type":     self.repetitionsType.rawValue
        ]
        
        if let barbellType = self.barbellType {
            json["barbell_type"] = barbellType.rawValue
        }
        
        if let restIntervalSec = self.restIntervalSec {
            json["rest_interval_sec"] = String(restIntervalSec)
        }
        
        return json
    }
}