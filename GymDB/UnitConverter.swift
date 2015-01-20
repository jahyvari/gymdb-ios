//
//  UnitConverter.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 20.1.2015.
//  Copyright (c) 2015 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

class UnitConverter {
    class var LB_TO_KG: Float {
        get {
            return 2.20462262
        }
    }
    
    class func lbToKG(lb: Float) -> Float {
        return lb / self.LB_TO_KG
    }
    
    class func kgToLB(kg: Float) -> Float {
        return kg * self.LB_TO_KG
    }
}