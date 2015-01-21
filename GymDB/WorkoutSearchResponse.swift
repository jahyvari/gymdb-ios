//
//  WorkoutSearchResponse.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 21.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

struct WorkoutSearchResponse {
    var hashId:         String
    var extratext:      String
    var startTime:      String
    var durationMin:    Int
    var exercises:      UInt?
    var sets:           UInt?
    var repetitions:    UInt?
    
    init(var hashId: String, var extratext: String, var startTime: String, var durationMin: Int, var exercises: UInt?, var sets: UInt?, var repetitions: UInt?) {
        self.hashId         = hashId
        self.extratext      = extratext
        self.startTime      = startTime
        self.durationMin    = durationMin
        self.exercises      = exercises
        self.sets           = sets
        self.repetitions    = repetitions
    }
}