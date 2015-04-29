//
//  User.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 31.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class User: UserProtocol {
    var hashid:         String
    var email:          String
    var firstname:      String?
    var lastname:       String?
    var default_unit:   Unit
    var timezoneid:     UInt
    var timeout_min:    UInt
    
    init(hashid: String, email: String, firstname: String?, lastname: String?, timezoneid: UInt, default_unit: Unit, timeout_min: UInt) {
        self.hashid         = hashid
        self.email          = email
        self.firstname      = firstname
        self.lastname       = lastname
        self.timezoneid     = timezoneid
        self.default_unit   = default_unit
        self.timeout_min    = timeout_min
    }
    
    required init(data: AnyObject) {
        self.hashid         = data["hashid"] as! String
        self.email          = data["email"] as! String
        self.firstname      = data["firstname"] as? String
        self.lastname       = data["lastname"] as? String
        self.timezoneid     = UInt((data["timezoneid"] as! String).toInt()!)
        self.default_unit   = Unit.fromString(data["default_unit"] as! String)!
        self.timeout_min    = UInt((data["timeout_min"] as! String).toInt()!)
    }
    
    func save(inout apiResponse: GymDBAPIResponse?, password: String?, password2: String?) -> Bool {
        var result = false
        
        var json = self.toJSONObject()
        
        if password != nil {
            json["password"] = password
        }
        if password2 != nil {
            json["password2"] = password2
        }
        
        GymDBAPI.postRequest("User", functionName: "save", data: json)
        
        apiResponse = GymDBAPI.lastAPIResponse!
        
        if (apiResponse!.code == 0) {
            result = true
        }
        
        return result
    }
    
    func toJSONObject() -> [String: AnyObject] {
        var json: [String: AnyObject] = [
            "hashid":       self.hashid,
            "email":        self.email,
            "timezoneid":   String(self.timezoneid),
            "default_unit": self.default_unit.rawValue,
            "timeout_min":  String(self.timeout_min)
        ]
        
        if let firstname = self.firstname {
            json["firstname"] = firstname
        }
        
        if let lastname = self.lastname {
            json["lastname"] = lastname
        }
        
        return json
    }
}