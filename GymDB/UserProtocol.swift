//
//  UserProtocol.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 31.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

protocol UserProtocol {
    init(data: AnyObject)
    
    func save(inout apiResponse: GymDBAPIResponse?, password: String?, password2: String?) -> Bool
    
    func toJSONObject() -> [String: AnyObject]
}