//
//  UserWeightProtocol.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 14.2.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

protocol UserWeightProtocol {
    init(data: AnyObject)
    
    func toJSONObject() -> [String: AnyObject]
}