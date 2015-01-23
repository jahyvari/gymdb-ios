//
//  TrainingProgramScheduleResponse.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 23.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

struct TrainingProgramScheduleResponse {
    var hashId:             String
    var programName:        String
    var templateHashId:     String
    var templateExtratext:  String
    var workoutDate:        String
    
    init(hashId: String, programName: String, templateHashId: String, templateExtratext: String, workoutDate: String) {
        self.hashId             = hashId
        self.programName        = programName
        self.templateHashId     = templateHashId
        self.templateExtratext  = templateExtratext
        self.workoutDate        = workoutDate
    }
}