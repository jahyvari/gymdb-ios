//
//  GymDBAPIResponse.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

struct GymDBAPIResponse {
    var code:           Int
    var reasonCode:     Int?
    var reasonSource:   String?
    var reasonKey:      String?
    var keyDesc:        String?
    var iteration:      [String: Int]?
    var sourceDesc:     [String: String]?
    var text:           String
    var data:           AnyObject?
    
    init(code: Int = 9999, text: String = "Unknown error occured!") {
        self.code = code
        self.text = text
    }
    
    init(code: Int, reasonCode: Int?, reasonSource: String?, reasonKey: String?, keyDesc: String?, iteration: [String: Int]?, sourceDesc: [String: String]?, text: String, data: AnyObject?) {
        self.code           = code
        self.reasonCode     = reasonCode
        self.reasonSource   = reasonSource
        self.reasonKey      = reasonKey
        self.keyDesc        = keyDesc
        self.iteration      = iteration
        self.sourceDesc     = sourceDesc
        self.text           = text
        self.data           = data
    }
}