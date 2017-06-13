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
    
    private static let LastModifiedKey = "last_modified"
    
    public func userStatusEndpointHandler(data: [String:Any]) throws -> RequestHandler {
        return {
            request, response in
            
            response.status = .ok
            response.setHeader(.contentType, value: ServerContentType.JSON)
            var jsonResponse: [String:String] = [:]
            
            do {
                let usersFile = File(UsersEndpoint.UsersFilename)
                jsonResponse[UsersEndpoint.LastModifiedKey] = String(usersFile.modificationTime)
                try response.setBody(json: jsonResponse)
            } catch {
                response.status = .internalServerError
                response.appendBody(string: "Error.")
            }
            
            response.completed()
        }
    }
}
