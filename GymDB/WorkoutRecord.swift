//
//  WorkoutRecord.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 23.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class WorkoutRecord: WorkoutProtocol {
    var record: String
    
    init(record: String) {
        self.record = record
    }
    
    required init(data: AnyObject) {
        self.record = data["record"] as String
    }
    
    required init(templateData: AnyObject) {
        self.record = templateData["record"] as String
    }
    
    func save(inout apiResponse: GymDBAPIResponse?) -> Bool {
        return false
    }
    
    func toJSONObject() -> [String : AnyObject] {
        var json: [String: AnyObject] = [
            "record": self.record
        ]
        
        return json
    }
}