//
//  GymDBAPI.swift
//  GymDB
//
//  Created by Jarkko Hyvärinen on 29.12.2014.
//  Copyright (c) 2014 Jarkko Hyvärinen. All rights reserved.
//

import Foundation

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
    
    class func exerciseGetList() -> [ExerciseCategory]? {
        var result: [ExerciseCategory]?
        
        self.postRequest("Exercise", functionName: "getList", data: nil)
        
        if self.lastAPIResponse!.code == 0 {
            if let data = self.lastAPIResponse!.data as? [String: [String: [String: String]]] {
                result = [ExerciseCategory]()
                
                for (category,musclegroups) in data {
                    var currentCategory = ExerciseCategories.Other
                    if let _currentCategory = ExerciseCategories.fromString(category) {
                        currentCategory = _currentCategory
                    }
                    
                    var groupDict: [Musclegroup: [Exercise]] = [:]
                    
                    for (musclegroup,exercises) in musclegroups {
                        var currentMusclegroup = Musclegroup.Other
                        if let _currentMusclegroup = Musclegroup.fromString(musclegroup) {
                            currentMusclegroup = _currentMusclegroup
                        }
                        
                        var exerciseArr: [Exercise] = [Exercise]()
                        
                        for (exerciseId,exerciseName) in exercises {
                            let exercise = Exercise(id: UInt(exerciseId.toInt()!), name: exerciseName, exerciseCategory: currentCategory, musclegroup: currentMusclegroup)
                            
                            exerciseArr.append(exercise)
                        }
                        
                        groupDict[currentMusclegroup] = exerciseArr
                    }
                    
                    result!.append(ExerciseCategory(category: currentCategory, exercises: groupDict))
                }
            }
        }
        
        return result
    }
    
    class func locationGetList() -> [String: String]? {
        var result: [String: String]?
        
        self.postRequest("Location", functionName: "getList", data: nil)
        
        if self.lastAPIResponse!.code == 0 {
            if let data = self.lastAPIResponse!.data as? [String: String] {
                result = data
            }
        }
        
        return result
    }
        
    class func postRequest(className: String, functionName: String, data: AnyObject?) -> Bool {
        var result = false
        var response = GymDBAPIResponse()
        
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
            if (round(Float(NSDate().timeIntervalSince1970)*1000) - refresh) > 1500 {
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
    
    class func timeZoneGetList() -> [UInt: String]? {
        var result: [UInt: String]?
        
        self.postRequest("TimeZone", functionName: "getList", data: nil)
        
        if self.lastAPIResponse!.code == 0 {
            if let data = self.lastAPIResponse!.data as? [String: String] {
                result = [UInt: String]()
                
                for (key,value) in data {
                    result?.updateValue(value, forKey: UInt(key.toInt()!))
                }
            }
        }
        
        return result
    }
    
    class func trainingProgramSchedule(startDate: String?, endDate: String?, pos: UInt?, count: UInt?) -> [TrainingProgramScheduleResponse]? {
        var result: [TrainingProgramScheduleResponse]?
        var data: [String: String] = [:]
        
        if startDate != nil {
            data["startdate"] = startDate!
        }
        if endDate != nil {
            data["enddate"] = endDate!
        }
        if pos != nil {
            data["pos"] = String(pos!)
        }
        if count != nil {
            data["count"] = String(count!)
        }
        
        self.postRequest("TrainingProgram", functionName: "schedule", data: data.count > 0 ? data: nil)
        
        if self.lastAPIResponse!.code == 0 {
            if let data = self.lastAPIResponse!.data as? [String: AnyObject] {
                if let list = data["list"] as? [[String: AnyObject]] {
                    for value in list {
                        if result == nil {
                            result = [TrainingProgramScheduleResponse]()
                        }
                        
                        let hashId              = value["hashid"] as String
                        let programName         = value["program_name"] as String
                        let templateHashId      = value["templatehashid"] as String
                        let templateExtratext   = value["template_extratext"] as String
                        let workoutDate         = value["workout_date"] as String
                        
                        result!.append(TrainingProgramScheduleResponse(hashId: hashId, programName: programName, templateHashId: templateHashId, templateExtratext: templateExtratext, workoutDate: workoutDate))
                    }
                }
            }
        }
        
        return result
    }
    
    class func userLoad() -> User? {
        var result: User?
        
        self.postRequest("User", functionName: "load", data: nil)
        
        if self.lastAPIResponse!.code == 0 {
            result = User(data: self.lastAPIResponse!.data!)
        }
        
        return result
    }
    
    class func workoutDelete(hashId: String) -> Bool {
        var result = false
        
        self.postRequest("Workout", functionName: "delete", data: ["hashid": hashId])
        
        if self.lastAPIResponse!.code == 0 {
            result = true
        }
        
        return result
    }
    
    class func workoutLoad(hashId: String) -> Workout? {
        var result: Workout?
        
        self.postRequest("Workout", functionName: "load", data: ["hashid": hashId])
        
        if self.lastAPIResponse!.code == 0 {
            result = Workout(data: self.lastAPIResponse!.data!)
        }
        
        return result
    }
    
    class func workoutLoadFromTemplate(templateHashId: String) -> Workout? {
        var result: Workout?
        
        self.postRequest("Template", functionName: "load", data: ["hashid": templateHashId])
        
        if self.lastAPIResponse!.code == 0 {
            result = Workout(templateData: self.lastAPIResponse!.data!)
        }
        
        return result
    }
    
    class func workoutSearch(startDate: String?, endDate: String?, pos: UInt?, count: UInt?) -> [WorkoutSearchResponse]? {
        var result: [WorkoutSearchResponse]?
        var data: [String: String] = [:]
        
        if startDate != nil {
            data["startdate"] = startDate!
        }
        if endDate != nil {
            data["enddate"] = endDate!
        }
        if pos != nil {
            data["pos"] = String(pos!)
        }
        if count != nil {
            data["count"] = String(count!)
        }
        
        self.postRequest("Workout", functionName: "search", data: data.count > 0 ? data: nil)
        
        if self.lastAPIResponse!.code == 0 {
            if let data = self.lastAPIResponse!.data as? [String: AnyObject] {
                if let list = data["list"] as? [[String: AnyObject]] {
                    for value in list {
                        if result == nil {
                            result = [WorkoutSearchResponse]()
                        }
                        
                        let hashId      = value["hashid"] as String
                        let extratext   = value["extratext"] as String
                        let startTime   = value["starttime"] as String
                        let durationMin = (value["duration_min"] as String).toInt()!
                        
                        var exercises: UInt?
                        if let _exercises = value["duration_min"] as? String {
                            exercises = UInt(_exercises.toInt()!)
                        }
                        
                        var sets: UInt?
                        if let _sets = value["sets"] as? String {
                            sets = UInt(_sets.toInt()!)
                        }
                        
                        var repetitions: UInt?
                        if let _repetitions = value["repetitions"] as? String {
                            repetitions = UInt(_repetitions.toInt()!)
                        }
                        
                        result!.append(WorkoutSearchResponse(hashId: hashId, extratext: extratext, startTime: startTime, durationMin: durationMin, exercises: exercises, sets: sets, repetitions: repetitions))
                    }
                }
            }
        }
        
        return result
    }
}