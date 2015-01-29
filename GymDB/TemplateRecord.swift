//
//  TemplateRecord.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class TemplateRecord: TemplateProtocol {
    var record: String
    
    init(record: String) {
        self.record = record
    }
    
    required init(data: AnyObject) {
        self.record = data["record"] as String
    }
}