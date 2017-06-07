//
//  EndpointLogger.swift
//  PerfectServerTest
//
//  Created by Dinesh Harjani on 07/06/2017.
//
//

import Foundation
import PerfectHTTP

public class EndpointLogger : NSObject {
    
    private struct NginxLoggerFilter: HTTPRequestFilter {
        
        static let LogFilename = "beaver.log"
        
        let logFileURL = URL(fileURLWithPath: LogFilename)
        
        func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
            
            print("Logging \(request)")
            let logger = NginxLogger(NginxLoggerFilter.LogFilename)
            logger.append("AA")
            
            callback(.continue(request, response))
        }
    }
    
    public static func nginxLoggingFilter(data: [String:Any]) throws -> HTTPRequestFilter {
        return NginxLoggerFilter()
    }
}
