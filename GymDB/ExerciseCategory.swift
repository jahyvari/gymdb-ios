//
//  ExerciseCategory.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 9.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

struct ExerciseCategory {
    var category:   ExerciseCategories
    var exercises:  [Musclegroup: [Exercise]]
    
    init(category: ExerciseCategories, exercises: [Musclegroup: [Exercise]]) {
        self.category   = category
        self.exercises  = exercises
    }
}