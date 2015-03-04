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
    
    var sortedMusclegroups: [Musclegroup] {
        get {
            return Array(self.exercises.keys).sorted({(item1,item2) -> Bool in
                return item1.description < item2.description
            })
        }
    }
    
    init(category: ExerciseCategories, exercises: [Musclegroup: [Exercise]]) {
        self.category   = category
        self.exercises  = exercises
    }
    
    func sortedExercisesByMusclegroup(musclegroup: Musclegroup) -> [Exercise]? {
        var result: [Exercise]?
        
        if let exercises = self.exercises[musclegroup] {
            result = exercises.sorted({(item1,item2) -> Bool in
                return item1.name < item2.name
            })
        }
        
        return result
    }
}