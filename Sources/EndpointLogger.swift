//
//  EndpointLogger.swift
//  PerfectServerTest
//
//  Created by Dinesh Harjani on 07/06/2017.
//
//

import Foundation
import SwiftyBeaver
import PerfectHTTP

public class EndpointLogger : NSObject {
    
    private struct SwiftyBeaverLoggerFilter: HTTPRequestFilter {
        func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
            print("Logging \(request)")
            callback(.continue(request, response))
        }
    }
    
    public static func swiftyBeaverLoggingFilter(data: [String:Any]) throws -> HTTPRequestFilter {
        return SwiftyBeaverLoggerFilter()
    }
}
