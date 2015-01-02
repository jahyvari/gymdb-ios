//
//  WorkoutProtocol.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 23.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

protocol WorkoutProtocol {
    init(data: AnyObject)
    
    func save(inout apiResponse: GymDBAPIResponse?) -> Bool
    
    func toJSONObject() -> [String: AnyObject]
}