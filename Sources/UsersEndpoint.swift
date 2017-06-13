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
                
                for category in usersDictionary {
                    var jsonCategory: [String:[[String:String]]] = [:]
                    
                    let paddockMembers = category.value[UserKeys.PaddockKey] as! [[String:String]]
                    jsonCategory[UserKeys.PaddockKey] = paddockMembers
                    
                    let pressMembers = category.value[UserKeys.PressKey] as! [[String:String]]
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
}
