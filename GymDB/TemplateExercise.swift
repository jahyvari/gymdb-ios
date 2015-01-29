//
//  TemplateExercise.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class TemplateExercise: TemplateProtocol {
    var unit:               Unit
    var extratext:          String?
    var special:            Special?
    var gearBelt:           UInt8
    var gearKneeWraps:      UInt8
    var gearShirt:          UInt8
    var gearSuit:           UInt8
    var gearWristStraps:    UInt8
    var gearWristWraps:     UInt8
    var sets:               [TemplateExerciseSet]?
    
    init(unit: Unit, extratext: String?, special: Special?, gearBelt: UInt8, gearKneeWraps: UInt8, gearShirt: UInt8, gearSuit: UInt8, gearWristStraps: UInt8, gearWristWraps: UInt8, sets: [TemplateExerciseSet]?) {
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
                    self.sets = [TemplateExerciseSet]()
                }
                self.sets?.append(TemplateExerciseSet(data: set))
                i++
            }
        }
    }
}