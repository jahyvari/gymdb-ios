//
//  Enums.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 22.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

enum BarbellType: String {
    case BuffaloBar     = "buffalo_bar"
    case CamberedBar    = "cambered_bar"
    case CurlBar        = "curl_bar"
    case OlympicBar     = "olympic_bar"
    case SafetyBar      = "safety_bar"
    case StandardBar    = "standard_bar"
    case SwissBar       = "swiss_bar"
    case ThickBar       = "thick_bar"
    case TrapBar        = "trap_bar"
    
    static var allValues: [BarbellType] = [
        BuffaloBar,
        CamberedBar,
        CurlBar,
        OlympicBar,
        SafetyBar,
        StandardBar,
        SwissBar,
        ThickBar,
        TrapBar
    ]
    
    static func fromString(barbellType: String) -> BarbellType? {
        var result: BarbellType?
        
        if let type = self(rawValue: barbellType) {
            result = type
        }
        
        return result
    }
}

enum ExerciseCategories: String {
    case Barbell        = "Barbell"
    case Bodyweight     = "Bodyweight"
    case Cable          = "Cable"
    case Dumbell        = "Dumbell"
    case Kettlebell     = "Kettlebell"
    case Machine        = "Machine"
    case Other          = "Other"
    case Ring           = "Ring"
    
    static var allValues: [ExerciseCategories] = [
        Barbell,
        Bodyweight,
        Cable,
        Dumbell,
        Kettlebell,
        Machine,
        Other,
        Ring
    ]
    
    static func fromString(categoryName: String) -> ExerciseCategories? {
        var result: ExerciseCategories?
        
        if let category = self(rawValue: categoryName) {
            result = category
        }
        
        return result
    }
}

enum Musclegroup: String {
    case Abs        = "Abs"
    case Back       = "Back"
    case Biceps     = "Biceps"
    case Calfs      = "Calfs"
    case Chest      = "Chest"
    case Forearms   = "Forearms"
    case Legs       = "Legs"
    case Shoulders  = "Shoulders"
    case Triceps    = "Triceps"
    case Other      = "Other"
    
    static var allValues: [Musclegroup] = [
        Abs,
        Back,
        Biceps,
        Calfs,
        Chest,
        Forearms,
        Legs,
        Shoulders,
        Triceps,
        Other
    ]
    
    static func fromString(musclegroup: String) -> Musclegroup? {
        var result: Musclegroup?
        
        if let group = self(rawValue: musclegroup) {
            result = group
        }
        
        return result
    }
}

enum RepetionsType: String {
    case Forced     = "forced"
    case MaxAttempt = "max_attempt"
    case Negative   = "negative"
    case Normal     = "normal"
    case Partial    = "partial"
    
    static var allValues: [RepetionsType] = [
        Forced,
        MaxAttempt,
        Negative,
        Normal,
        Partial
    ]
    
    static func fromString(repetitionsType: String) -> RepetionsType? {
        var result: RepetionsType?
        
        if let type = self(rawValue: repetitionsType) {
            result = type
        }
        
        return result
    }
}

enum Special: String {
    case DropSet    = "dropset"
    case GiantSet   = "giantset"
    case Pair       = "pair"
    case RestPause  = "rest_pause"
    case SuperSet   = "superset"
    case TripleSet  = "tripleset"
    
    static var allValues: [Special] = [
        DropSet,
        Pair,
        GiantSet,
        RestPause,
        SuperSet,
        TripleSet
    ]
    
    static func fromString(special: String) -> Special? {
        var result: Special?
        
        if let special = self(rawValue: special) {
            result = special
        }
        
        return result
    }
    
    var description: String {
        get {
            switch self {
                case .DropSet:
                    return "Dropset"
                case .GiantSet:
                    return "Giant set"
                case Pair:
                    return "Exercise pair"
                case .RestPause:
                    return "Rest-Pause"
                case .SuperSet:
                    return "Superset"
                case .TripleSet:
                    return "Triple set"
            }
        }
    }
}

enum Unit: String {
    case KG = "kg"
    case LB = "lb"
    
    static var allValues: [Unit] = [
        KG,
        LB
    ]
    
    static func fromString(unit: String) -> Unit? {
        var result: Unit?
        
        if let unit = self(rawValue: unit) {
            result = unit
        }
        
        return result
    }
}