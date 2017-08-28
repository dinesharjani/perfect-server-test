//
//  UsersEndpoint.swift
//  PerfectServerTest
//
//  Created by Dinesh Harjani on 13/06/2017.
//
//

import Foundation
import PerfectHTTP
import PerfectLib

public class UsersEndpoint : NSObject {
    
    static let Name = "users"
    static let StatusName = "status"
    static let UsersFilename = "Resources/Users.plist"
    
    private enum Language : String {
        case English = "en"
        case Spanish = "es"
        case Mexican = "es-MX"
        
        static func isValidLanguage(_ language: String) -> Bool {
            if language == Language.English.rawValue {
                return true
            } else if language == Language.Spanish.rawValue {
                return true
            } else if language == Language.Mexican.rawValue {
                return true
            }
            
            return false
        }
    }
    
    private enum UserKeys {
        static let PaddockKey = "paddock"
        static let PressKey = "press"
        
        static let LastModifiedKey = "last_modified"
    }
    
    public func userStatusEndpointHandler(data: [String:Any]) throws -> RequestHandler {
        return {
            request, response in
            
            response.status = .ok
            response.setHeader(.contentType, value: ServerContentType.JSON)
            var jsonResponse: [String:String] = [:]
            
            do {
                let usersFile = File(UsersEndpoint.UsersFilename)
                jsonResponse[UserKeys.LastModifiedKey] = String(usersFile.modificationTime)
                try response.setBody(json: jsonResponse)
            } catch {
                response.status = .internalServerError
                response.appendBody(string: "Error.")
            }
            
            response.completed()
        }
    }
    
    public func usersEndpointHandler(data: [String:Any]) throws -> RequestHandler {
        return {
            request, response in
            
            response.status = .ok
            response.setHeader(.contentType, value: ServerContentType.JSON)
            
            var jsonResponse: [String:Any] = [:]
            do {
                let usersFile = File(UsersEndpoint.UsersFilename)
                let data = try Data(contentsOf:URL(fileURLWithPath:usersFile.realPath))
                let usersDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:[String:Any]]
                
                let language = self.requestParameterLanguage(request)
                for category in usersDictionary {
                    var jsonCategory: [String:[[String:String]]] = [:]
                    
                    let paddockMembers = self.filter(users: category.value[UserKeys.PaddockKey] as! [[String:String]], language: language)
                    jsonCategory[UserKeys.PaddockKey] = paddockMembers
                    
                    let pressMembers = self.filter(users: category.value[UserKeys.PressKey] as! [[String:String]], language: language)
                    jsonCategory[UserKeys.PressKey] = pressMembers
                    
                    jsonResponse[category.key] = jsonCategory
                }
                
                try response.setBody(json: jsonResponse)
            } catch {
                response.status = .internalServerError
                response.appendBody(string: "Error.")
            }
            response.completed()
        }
    }
    
    public func filter(users: [[String : String]], language : String) -> [[String : String]] {
        var filteredUsers = [[String : String]]()
        for user in users {
            var filteredUser = user
            for (userKey, _) in filteredUser {
                if Language.isValidLanguage(userKey) && language != userKey {
                    filteredUser.removeValue(forKey: userKey)
                }
            }
            filteredUsers.append(filteredUser)
        }
        
        return filteredUsers
    }
    
    public func requestParameterLanguage(_ request: HTTPRequest) -> String {
        for (parameter, value) in request.queryParams {
            if parameter == "language" && Language.isValidLanguage(value) {
                return value
            }
        }
        
        return "en"
    }
}
