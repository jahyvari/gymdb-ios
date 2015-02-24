//
//  UserWeight.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 14.2.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class UserWeight: UserWeightProtocol {
    var hashId:             String?
    var userId:             UInt?
    var weightKG:           Float
    var weightLB:           Float
    var unit:               Unit
    var measurementTime:    MeasurementTime
    var fatPercent:         Float?
    var date:               String
    
    init(hashId: String?, userId: UInt?, weightKG: Float, weightLB: Float, unit: Unit, measurementTime: MeasurementTime, fatPercent: Float?, date: String) {
        self.hashId             = hashId
        self.userId             = userId
        self.weightKG           = weightKG
        self.weightLB           = weightLB
        self.unit               = unit
        self.measurementTime    = measurementTime
        self.fatPercent         = fatPercent
        self.date               = date
    }
    
    required init(data: AnyObject) {
        self.hashId             = data["hashid"] as? String
        self.weightKG           = NSNumberFormatter().numberFromString(data["weight_kg"] as String)!.floatValue
        self.weightLB           = NSNumberFormatter().numberFromString(data["weight_lb"] as String)!.floatValue
        self.unit               = Unit.fromString(data["unit"] as String)!
        self.measurementTime    = MeasurementTime.fromString(data["measurement_time"] as String)!
        self.date               = data["date"] as String
        
        if let userId = data["userid"] as? String {
            self.userId = UInt(userId.toInt()!)
        }
        
        if let fatPercent = data["fatpercent"] as? String {
            self.fatPercent = NSNumberFormatter().numberFromString(fatPercent)!.floatValue
        }
    }
    
    func toJSONObject() -> [String: AnyObject] {
        var json: [String: AnyObject] = [
            "weight_kg":        NSString(format: "%.2f", self.weightKG),
            "weight_lb":        NSString(format: "%.2f", self.weightLB),
            "unit":             self.unit.rawValue,
            "measurement_time": self.measurementTime.rawValue,
            "date":             self.date
        ]
        
        if let hashId = self.hashId {
            json["hashid"] = hashId
        }
        
        if let userId = self.userId {
            json["userid"] = String(userId)
        }
        
        if let fatPercent = self.fatPercent {
            json["fatpercent"] = NSString(format: "%.2f", fatPercent)
        }
        
        return json
    }
}