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
    
    private struct CLFResponseLoggerFilter: HTTPRequestFilter {
        
        static let LogFilename = "beaver.log"
        
        let logFileURL = URL(fileURLWithPath: LogFilename)
        
        func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
            let logger = CLFResponseLogger(CLFResponseLoggerFilter.LogFilename)
            logger.log(request, response: response)
            
            callback(.continue(request, response))
        }
    }
    
    public static func clfResponseLoggingFilter(data: [String:Any]) throws -> HTTPRequestFilter {
        return CLFResponseLoggerFilter()
    }
}
