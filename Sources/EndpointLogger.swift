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
    
    private struct CLFResponseLoggerFilter: HTTPResponseFilter {
        
        static let LogFilename = "beaver.log"
        
        let logFileURL = URL(fileURLWithPath: LogFilename)
        
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            let logger = CLFResponseLogger(CLFResponseLoggerFilter.LogFilename)
            logger.log(response: response)
            
            callback(.continue)
        }
        
        // Implement HTTPResponseFilter
        public func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            // No-op.
            callback(.continue)
        }
    }
    
    public static func clfResponseLoggingFilter(data: [String:Any]) throws -> HTTPResponseFilter {
        return CLFResponseLoggerFilter()
    }
}
