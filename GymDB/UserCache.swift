//
//  UserCache.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 19.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class UserCache {
    private struct _cache {
        static var user: User?
    }
    
    class var user: User? {
        get {
            return _cache.user
        }
        set {
            _cache.user = newValue
        }
    }
}