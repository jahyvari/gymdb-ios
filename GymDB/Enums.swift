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
    
    static func fromString(barbellType: String) -> BarbellType? {
        var result: BarbellType?
        
        if let type = self(rawValue: barbellType) {
            result = type
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
    
    static func fromString(special: String) -> Special? {
        var result: Special?
        
        if let special = self(rawValue: special) {
            result = special
        }
        
        return result
    }
}

enum Unit: String {
    case KG = "kg"
    case LB = "lb"
    
    static func fromString(unit: String) -> Unit? {
        var result: Unit?
        
        if let unit = self(rawValue: unit) {
            result = unit
        }
        
        return result
    }
}