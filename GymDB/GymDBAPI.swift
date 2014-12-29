//
//  GymDBAPI.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation
import UIKit

class GymDBAPI {
    private struct _data {
        static var defaultEmailKey:     String = "userEmail"
        static var defaultPasswordKey:  String = "userPassword"
        static var lastAPIResponse:     GymDBAPIResponse?
        static var lastRefresh:         Float?
        static var sessionId:           String?
    }
    
    class var defaultEmailKey: String {
        get {
            return _data.defaultEmailKey
        }
    }
    
    class var defaultPasswordKey: String {
        get {
            return _data.defaultPasswordKey
        }
    }
    
    class var loged: Bool {
        get {
            if _data.sessionId != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    class var lastAPIResponse: GymDBAPIResponse? {
        get {
            return _data.lastAPIResponse
        }
        set {
            _data.lastAPIResponse = newValue
        }
    }
    
    class var lastRefresh: Float? {
        get {
            return _data.lastRefresh
        }
        set {
            _data.lastRefresh = newValue
        }
    }
    
    class var sessionId: String? {
        get {
            return _data.sessionId
        }
        set {
            _data.sessionId = newValue
        }
    }
    
    class func doLogin(email: String, password: String) -> Bool {
        var result = false
        
        let data: [String: String] = [
            "email":    email,
            "password": password
        ]
        
        self.postRequest("Login", functionName: "doLogin", data: data)
        
        if self.lastAPIResponse!.code == 0 {
            if let sessionId = self.lastAPIResponse!.data as? String {
                self.sessionId = sessionId
                self.lastRefresh = round(Float(NSDate().timeIntervalSince1970)*1000)
                
                NSUserDefaults.standardUserDefaults().setValue(email, forKey: self.defaultEmailKey)
                NSUserDefaults.standardUserDefaults().setValue(password, forKey: self.defaultPasswordKey)
                
                result = true
            }
        }
        
        return result
    }
    
    class func doLoginWithDefaults() -> Bool {
        var result = false
        
        let email = NSUserDefaults.standardUserDefaults().valueForKey(self.defaultEmailKey) as? String
        let password = NSUserDefaults.standardUserDefaults().valueForKey(self.defaultPasswordKey) as? String
        
        if email != nil && password != nil {
            result = self.doLogin(email!, password: password!)
        }
        
        return result
    }
    
    class func doLogout() -> Bool {
        var result = false
        
        if (self.loged) {
            self.postRequest("Login", functionName: "doLogout", data: nil)
        
            self.sessionId = nil
            self.lastRefresh = nil
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey(self.defaultEmailKey)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(self.defaultPasswordKey)
            
            result = true
        }
        
        return result
    }
        
    class func postRequest(className: String, functionName: String, data: AnyObject?) -> Bool {
        var result = false
        var response = GymDBAPIResponse(code: 9999, text: "Unknown error occured!")
        
        let apiURL = "http://localhost/gymdb/trunk/API/request/"
        if let url = NSURL(string: apiURL+className+"/"+functionName) {
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if self.loged {
                request.setValue(self.sessionId!, forHTTPHeaderField: "x-sessionid")
            }
            
            if data != nil && NSJSONSerialization.isValidJSONObject(data!) {
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(data!, options: nil, error: nil)
            }
            
            var error: NSError?
            let returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: &error)
            
            if error == nil && returnData != nil {
                let json = NSJSONSerialization.JSONObjectWithData(returnData!, options: .MutableContainers, error: nil) as? NSDictionary
                
                if let jsonData = json {
                    response.code         = jsonData["code"] as Int
                    response.reasonCode   = jsonData["reasonCode"] as? Int
                    response.reasonSource = jsonData["reasonSource"] as? String
                    response.reasonKey    = jsonData["reasonKey"] as? String
                    response.keyDesc      = jsonData["keyDesc"] as? String
                    response.iteration    = jsonData["iteration"] as? [String: Int]
                    response.sourceDesc   = jsonData["sourceDesc"] as? [String: String]
                    response.text         = jsonData["text"] as String
                    response.data         = jsonData["data"]
                    
                    // Clear sessionId if session is timed out
                    if response.code == 10 && response.reasonCode != nil {
                        if response.reasonCode! == 60 {
                            self.sessionId = nil
                        }
                    }
                    
                    result = true
                }
            }
        }
        
        self.lastAPIResponse = response
        
        return result
    }
    
    class func refreshLogin(force: Bool = false) -> Bool {
        var result = true
        
        if let refresh = self.lastRefresh {
            if (round(Float(NSDate().timeIntervalSince1970)*1000) - refresh) > 3300 {
                self.postRequest("Login", functionName: "refreshLogin", data: nil)
                
                if self.lastAPIResponse!.code == 0 {
                    self.lastRefresh = round(Float(NSDate().timeIntervalSince1970)*1000)
                } else if force {
                    result = self.doLoginWithDefaults()
                } else {
                    result = false
                }
            }
        } else if force {
            result = self.doLoginWithDefaults()
        } else {
            result = false
        }
        
        return result
    }
}