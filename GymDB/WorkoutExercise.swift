//
//  WorkoutExercise.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 22.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class WorkoutExercise: WorkoutProtocol {
    var unit:               Unit
    var extratext:          String?
    var special:            Special?
    var gearBelt:           UInt8
    var gearKneeWraps:      UInt8
    var gearShirt:          UInt8
    var gearSuit:           UInt8
    var gearWristStraps:    UInt8
    var gearWristWraps:     UInt8
    var sets:               [WorkoutExerciseSet]?
    
    init(unit: Unit, extratext: String?, special: Special?, gearBelt: UInt8, gearKneeWraps: UInt8, gearShirt: UInt8, gearSuit: UInt8, gearWristStraps: UInt8, gearWristWraps: UInt8, sets: [WorkoutExerciseSet]?) {
        self.unit               = unit
        self.extratext          = extratext
        self.special            = special
        self.gearBelt           = gearBelt
        self.gearKneeWraps      = gearKneeWraps
        self.gearShirt          = gearShirt
        self.gearSuit           = gearSuit
        self.gearWristStraps    = gearWristStraps
        self.gearWristWraps     = gearWristWraps
        self.sets               = sets
    }
    
    required init(data: AnyObject) {
        if let unit = Unit.fromString(data["unit"] as String) {
            self.unit = unit
        } else {
            self.unit = .KG
        }
        
        self.extratext = data["extratext"] as? String
        
        if let special = data["special"] as? String {
            self.special = Special.fromString(special)
        }
        
        self.gearBelt           = UInt8((data["gear_belt"] as String).toInt()!)
        self.gearKneeWraps      = UInt8((data["gear_knee_wraps"] as String).toInt()!)
        self.gearShirt          = UInt8((data["gear_shirt"] as String).toInt()!)
        self.gearSuit           = UInt8((data["gear_suit"] as String).toInt()!)
        self.gearWristStraps    = UInt8((data["gear_wrist_straps"] as String).toInt()!)
        self.gearWristWraps     = UInt8((data["gear_wrist_wraps"] as String).toInt()!)
        
        if let sets = data["sets"] as? [AnyObject] {
            var i = 0
            for set in sets {
                if i == 0 {
                    self.sets = [WorkoutExerciseSet]()
                }
                self.sets?.append(WorkoutExerciseSet(data: set))
                i++
            }
        }
    }
    
    required init(templateData: AnyObject) {
        if let unit = Unit.fromString(templateData["unit"] as String) {
            self.unit = unit
        } else {
            self.unit = .KG
        }
        
        self.extratext = templateData["extratext"] as? String
        
        if let special = templateData["special"] as? String {
            self.special = Special.fromString(special)
        }
        
        self.gearBelt           = UInt8((templateData["gear_belt"] as String).toInt()!)
        self.gearKneeWraps      = UInt8((templateData["gear_knee_wraps"] as String).toInt()!)
        self.gearShirt          = UInt8((templateData["gear_shirt"] as String).toInt()!)
        self.gearSuit           = UInt8((templateData["gear_suit"] as String).toInt()!)
        self.gearWristStraps    = UInt8((templateData["gear_wrist_straps"] as String).toInt()!)
        self.gearWristWraps     = UInt8((templateData["gear_wrist_wraps"] as String).toInt()!)
        
        if let sets = templateData["sets"] as? [AnyObject] {
            var i = 0
            for set in sets {
                if i == 0 {
                    self.sets = [WorkoutExerciseSet]()
                }
                self.sets?.append(WorkoutExerciseSet(templateData: set))
                i++
            }
        }
    }
    
    func save(inout apiResponse: GymDBAPIResponse?) -> Bool {
        return false
    }
    
    func toJSONObject() -> [String: AnyObject] {
        var sets: [[String: AnyObject]] = []
        if self.sets != nil {
            for set in self.sets! {
                sets.append(set.toJSONObject())
            }
        }
        
        var json: [String: AnyObject] = [
            "unit":                 self.unit.rawValue,
            "gear_belt":            String(self.gearBelt),
            "gear_knee_wraps":      String(self.gearKneeWraps),
            "gear_shirt":           String(self.gearShirt),
            "gear_suit":            String(self.gearSuit),
            "gear_wrist_straps":    String(self.gearWristStraps),
            "gear_wrist_wraps":     String(self.gearWristWraps),
            "sets":                 sets
        ]
        
        if let extratext = self.extratext {
            json["extratext"] = extratext
        }
        
        if let special = self.special {
            json["special"] = special.rawValue
        }
        
        if sets.count == 0 {
            json.removeValueForKey("sets")
        }
        
        return json
    }
}