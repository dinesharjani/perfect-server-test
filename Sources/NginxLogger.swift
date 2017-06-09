//
//  NginxLogger.swift
//  PerfectServerTest
//
//  Created by Dinesh Harjani on 07/06/2017.
//
//

import Foundation
import PerfectLib
import PerfectHTTP

public class NginxLogger : NSObject {
    
    private enum Constants {
        static let UnknownIPAddress = "X.X.X.X"
        static let UnknownUser = "Ghost"
    }
    
    private let file: File
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    public init(_ fileName: String) {
        self.file = File(fileName)
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MMM/yyyy"
        
        self.timeFormatter = DateFormatter()
        self.timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.timeFormatter.dateFormat = "HH:mm:ss ZZZZ"
        
        super.init()
    }
    
    // Logs in CLF (Common Log Format)
    // 127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326
    public func log(_ request: HTTPRequest, response: HTTPResponse) {
        let ipAddress = request.connection.remoteAddress != nil ? request.connection.remoteAddress!.host : Constants.UnknownIPAddress
        let user = Constants.UnknownUser
        
        let requestDateAndTime = Date()
        let date = dateFormatter.string(from: requestDateAndTime)
        let time = timeFormatter.string(from: requestDateAndTime)
        
        let requestType = request.method.description
        let requestEndpoint = request.uri
        let requestProtocol = "HTTP/\(request.protocolVersion.0).\(request.protocolVersion.1)"
        
        let responseStatus = response.status.code
        let responseSize = response.header(.contentLength) != nil ? response.header(.contentLength)! : "0"
        
        let loggedRequest = "\(ipAddress) - \(user) [\(date):\(time)] \"\(requestType) \(requestEndpoint) \(requestProtocol)\" \(responseStatus) \(responseSize)"
        append(loggedRequest)
        print(loggedRequest)
    }
    
    public func append(_ newLine: String) {
        guard (file.exists) else {
            // New file
            do {
                try file.open(.write, permissions: .rwUserGroup)
                try file.write(string: newLine + "\n")
                file.close()
            } catch {
                print("Er - we couldn't write to \(file.realPath)")
            }
            
            return
        }
        
        do {
            try file.open(.append, permissions: .rwUserGroup)
            try file.write(string: newLine + "\n")
            file.close()
        } catch {
            print("Er - we couldn't append to \(file.realPath)")
        }
    }
}
