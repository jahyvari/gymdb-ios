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
    
    var description: String {
        get {
            switch self {
                case .BuffaloBar:
                    return "Buffalo bar"
                case .CamberedBar:
                    return "Cambered bar"
                case .CurlBar:
                    return "Curl bar"
                case .OlympicBar:
                    return "Olympic bar"
                case .SafetyBar:
                    return "Safety bar"
                case .StandardBar:
                    return "Standard bar"
                case .SwissBar:
                    return "Swiss bar"
                case .ThickBar:
                    return "Thick bar"
                case .TrapBar:
                    return "Trap bar"
            }
        }
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
    case Smith          = "Smith"
    
    static var allValues: [ExerciseCategories] = [
        Barbell,
        Bodyweight,
        Cable,
        Dumbell,
        Kettlebell,
        Machine,
        Other,
        Ring,
        Smith
    ]
    
    static func fromString(categoryName: String) -> ExerciseCategories? {
        var result: ExerciseCategories?
        
        if let category = self(rawValue: categoryName) {
            result = category
        }
        
        return result
    }
    
    var description: String {
        get {
            switch self {
                case .Barbell:
                    return "Barbell"
                case .Bodyweight:
                    return "Bodyweight"
                case .Cable:
                    return "Cable"
                case .Dumbell:
                    return "Dumbell"
                case .Kettlebell:
                    return "Kettlebell"
                case .Machine:
                    return "Machine"
                case .Other:
                    return "Other"
                case .Ring:
                    return "Ring"
                case .Smith:
                    return "Smith"
                
            }
        }
    }
}

enum MeasurementTime: String {
    case Evening = "evening"
    case Morning = "morning"
    
    static var allValues: [MeasurementTime] = [
        Evening,
        Morning
    ]
    
    static func fromString(unit: String) -> MeasurementTime? {
        var result: MeasurementTime?
        
        if let unit = self(rawValue: unit) {
            result = unit
        }
        
        return result
    }
    
    var description: String {
        get {
            switch self {
                case .Evening:
                    return "Evening"
                case .Morning:
                    return "Morning"
            }
        }
    }
}

enum Musclegroup: String {
    case Abs        = "Abs"
    case Back       = "Back"
    case Biceps     = "Biceps"
    case Calfs      = "Calfs"
    case Chest      = "Chest"
    case FullBody   = "Full-body"
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
        FullBody,
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
    
    var description: String {
        get {
            switch self {
                case .Abs:
                    return "Abs"
                case .Back:
                    return "Back"
                case .Biceps:
                    return "Biceps"
                case .Calfs:
                    return "Calfs"
                case .Chest:
                    return "Chest"
                case .FullBody:
                    return "Full-body"
                case .Forearms:
                    return "Forearms"
                case .Legs:
                    return "Legs"
                case .Shoulders:
                    return "Shoulders"
                case .Triceps:
                    return "Triceps"
                case .Other:
                    return "Other"
            }
        }
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
    
    var description: String {
        get {
            switch self {
                case .Forced:
                    return "Forced"
                case .MaxAttempt:
                    return "Max attempt"
                case .Negative:
                    return "Negative"
                case .Normal:
                    return "Normal"
                case .Partial:
                    return "Partial"
            }
        }
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
    
    var description: String {
        get {
            switch self {
                case .KG:
                    return "KG"
                case .LB:
                    return "LB"
            }
        }
    }
}