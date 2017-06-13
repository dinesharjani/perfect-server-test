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
import Foundation

enum ServerContentType {
    static let JSON = "application/json"
}

enum PerfectTestServer {
    static let Name = "localhost"
    static let PrimaryApiPort = 8080
    static let RedirectApiPort = 8181
    
    static let ApiVersion = "v1"
}

let calendarEndpoint = CalendarEndpoint()
let usersEndpoint = UsersEndpoint()

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
                ["method":"get", "uri":"/\(PerfectTestServer.ApiVersion)/\(CalendarEndpoint.Name)/\(CalendarEndpoint.StatusName)", "handler":calendarEndpoint.calendarStatusEndpointHandler],
                ["method":"get", "uri":"/\(PerfectTestServer.ApiVersion)/\(UsersEndpoint.Name)/\(UsersEndpoint.StatusName)", "handler":usersEndpoint.userStatusEndpointHandler],
				["method":"get", "uri":"/\(PerfectTestServer.ApiVersion)/\(CalendarEndpoint.Name)", "handler":calendarEndpoint.calendarEndpointHandler]
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				],
				[
                "type":"request",
                "priority":"low",
                "name":EndpointLogger.clfResponseLoggingFilter,
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

