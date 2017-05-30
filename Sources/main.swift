//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

enum ServerContentType {
    static let JSON = "application/json"
}

enum PerfectTestServer {
    static let Name = "localhost"
    static let PrimaryApiPort = 8080
    static let RedirectApiPort = 8181
    
    static let ApiVersion = "v1"
}

enum CalendarEndpoint {
    static let Name = "calendar"
    static let CalendarFilename = "Calendar.plist"
}

func calendarEndpointHandler(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        
        response.status = .ok
        response.setHeader(.contentType, value: ServerContentType.JSON)
        
        let calendarFile = File(CalendarEndpoint.CalendarFilename)
        
        let jsonResponse = ["race1":"Indy 500", "race2":"Monaco GP"]
        do {
            try calendarFile.open(.read, permissions: .readUser)
            calendarFile.close()
            
            try response.setBody(json: jsonResponse)
        } catch {
            response.status = .internalServerError
            response.appendBody(string: "Error")
        }
        response.completed()
    }
}

let confData = [
	"servers": [
		// Configuration data for one server which:
		//	* Serves the hello world message at <host>:<port>/
		//	* Serves static files out of the "./webroot"
		//		directory (which must be located in the current working directory).
		//	* Performs content compression on outgoing data when appropriate.
		[
			"name":PerfectTestServer.Name,
			"port":PerfectTestServer.PrimaryApiPort,
			"routes":[
				["method":"get", "uri":"/\(PerfectTestServer.ApiVersion)/\(CalendarEndpoint.Name)", "handler":calendarEndpointHandler]
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		],
		// Configuration data for another server which:
		//	* Redirects all traffic back to the first server.
		[
			"name":PerfectTestServer.Name,
			"port":PerfectTestServer.RedirectApiPort,
			"routes":[
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.redirect,
				 "base":"http://\(PerfectTestServer.Name):\(PerfectTestServer.PrimaryApiPort)"]
			]
		]
	]
]

do {
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)")
}

