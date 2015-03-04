//
//  ExerciseCache.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 9.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class ExerciseCache {
    private struct _cache {
        static var exerciseCategories: [ExerciseCategory]?
    }
    
    class var exerciseCategories: [ExerciseCategory]? {
        get {
            return _cache.exerciseCategories
        }
        set {
            _cache.exerciseCategories = newValue
        }
    }
    
    class var sortedExerciseCategories: [ExerciseCategory]? {
        get {
            return _cache.exerciseCategories?.sorted({(item1,item2) -> Bool in
                return item1.category.description < item2.category.description
            })
        }
    }
    
    class func findByExerciseId(id: UInt) -> Exercise? {
        var result: Exercise?
        
        if self.exerciseCategories != nil {
            for category in self.exerciseCategories! {
                for (musclegroup,exercises) in category.exercises {
                    for exercise in exercises {
                        if exercise.id == id {
                            result = exercise
                            break
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    class func getFirstExercise() -> Exercise? {        
        if self.sortedExerciseCategories != nil {
            for category in self.sortedExerciseCategories! {
                for musclegroup in category.sortedMusclegroups {
                    for exercise in category.sortedExercisesByMusclegroup(musclegroup)! {
                        return exercise
                    }
                }
            }
        }
        
        return nil
    }
}