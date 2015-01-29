//
//  TemplateExerciseSet.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class TemplateExerciseSet: TemplateProtocol {
    var exerciseId:         UInt
    var repetitions:        UInt16
    var repetitionsEnd:     UInt16?
    var weightKG:           Float
    var weightLB:           Float
    var oneRepMaxPercent:   Float?
    var repetitionsType:    RepetionsType
    var barbellType:        BarbellType?
    var restIntervalSec:    UInt16?
    
    init(exerciseId: UInt, repetitions: UInt16, repetitionsEnd: UInt16?, weightKG: Float, weightLB: Float, oneRepMaxPercent: Float?, repetitionsType: RepetionsType, barbellType: BarbellType?, restIntervalSec: UInt16?) {
        self.exerciseId         = exerciseId
        self.repetitions        = repetitions
        self.repetitionsEnd     = repetitionsEnd
        self.weightKG           = weightKG
        self.weightLB           = weightLB
        self.oneRepMaxPercent   = oneRepMaxPercent
        self.repetitionsType    = repetitionsType
        self.barbellType        = barbellType
        self.restIntervalSec    = restIntervalSec
    }
    
    required init(data: AnyObject) {
        self.exerciseId         = UInt((data["exerciseid"] as String).toInt()!)
        self.repetitions        = UInt16((data["repetitions"] as String).toInt()!)
        self.weightKG           = NSNumberFormatter().numberFromString(data["weight_kg"] as String)!.floatValue
        self.weightLB           = NSNumberFormatter().numberFromString(data["weight_lb"] as String)!.floatValue
        
        if let repetitionsEnd = data["repetitions_end"] as? String {
            self.repetitionsEnd = UInt16(repetitionsEnd.toInt()!)
        }
        
        if let oneRepMaxPercent = data["onerepmax_percent"] as? String {
            self.oneRepMaxPercent = NSNumberFormatter().numberFromString(oneRepMaxPercent)!.floatValue
        }
        
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
}