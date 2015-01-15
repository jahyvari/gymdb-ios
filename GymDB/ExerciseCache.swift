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
        var result: Exercise?
        
        if self.exerciseCategories != nil {
            for category in self.exerciseCategories! {
                for (musclegroup,exercises) in category.exercises {
                    for exercise in exercises {
                        result = exercise
                        break
                    }
                }
            }
        }
        
        return result
    }
}