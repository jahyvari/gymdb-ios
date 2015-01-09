//
//  Exercise.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 9.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

struct Exercise {
    var id:                 UInt
    var name:               String
    var exerciseCategory:   ExerciseCategories
    var musglegroup:        Musclegroup
    
    init(id: UInt, name: String, exerciseCategory: ExerciseCategories, musclegroup: Musclegroup) {
        self.id                 = id
        self.name               = name
        self.exerciseCategory   = exerciseCategory
        self.musglegroup        = musclegroup
    }
}