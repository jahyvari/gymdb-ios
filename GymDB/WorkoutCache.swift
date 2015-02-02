//
//  WorkoutCache.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 6.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class WorkoutCache {
    private struct _cache {
        static var refreshList: Bool = false
        static var workout:     Workout?
    }
    
    class var refreshList: Bool {
        get {
            return _cache.refreshList
        }
        set {
            _cache.refreshList = newValue
        }
    }
    
    class var workout: Workout? {
        get {
            return _cache.workout
        }
        set {
            _cache.workout = newValue
        }
    }
}