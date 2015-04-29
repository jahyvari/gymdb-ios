//
//  Template.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class Template: TemplateProtocol {
    var hashId:     String?
    var extratext:  String
    var exercises:  [TemplateExercise]?
    var records:    [TemplateRecord]?
    
    init(hashId: String?, extratext: String, exercises: [TemplateExercise]?, records: [TemplateRecord]?) {
        self.hashId     = hashId
        self.extratext  = extratext
        self.exercises  = exercises
        self.records    = records
    }
    
    required init(data: AnyObject) {
        self.hashId     = data["hashid"] as? String
        self.extratext  = data["extratext"] as! String
        
        var i = 0
        
        if let exercises = data["exercises"] as? [AnyObject] {
            for exercise in exercises {
                if i == 0 {
                    self.exercises = [TemplateExercise]()
                }
                self.exercises?.append(TemplateExercise(data: exercise))
                i++
            }
        }
        
        if let records = data["records"] as? [AnyObject] {
            i = 0
            for record in records {
                if i == 0 {
                    self.records = [TemplateRecord]()
                }
                self.records?.append(TemplateRecord(data: record))
                i++
            }
        }
    }
}