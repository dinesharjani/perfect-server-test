//
//  CalendarEndpoint.swift
//  PerfectServerTest
//
//  Created by Dinesh Harjani on 31/05/2017.
//
//

import Foundation
import PerfectHTTP
import PerfectLib

public class CalendarEndpoint : NSObject {
    static let Name = "calendar"
    static let CalendarFilename = "Resources/Calendar.plist"
    
    private static let RaceFullNameXMLKey = "Promoter Name"
    private static let RaceDateXMLKey = "Race"
    
    private static let FullNameKey = "full_name"
    private static let DateKey = "date"
    
    let formatter = DateFormatter()
    
    override init() {
        super.init()
        
        self.formatter.dateStyle = .short
        self.formatter.timeStyle = .medium
    }
    
    public func calendarEndpointHandler(data: [String:Any]) throws -> RequestHandler {
        return {
            request, response in
            
            response.status = .ok
            response.setHeader(.contentType, value: ServerContentType.JSON)
            
            var jsonResponse: [String:Any] = [:]
            do {
                let calendarFile = File(CalendarEndpoint.CalendarFilename)
                let data = try Data(contentsOf:URL(fileURLWithPath:calendarFile.realPath))
                let calendarDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                for category in calendarDictionary {
                    var jsonEvents: [String:[String:Any]] = [:]
                    
                    let events = category.value as! [String:[String:Any]]
                    for event in events {
                        var jsonEvent: [String:String] = [:]
                        
                        jsonEvent[CalendarEndpoint.FullNameKey] = event.value[CalendarEndpoint.RaceFullNameXMLKey] as? String
                        let raceDate = event.value[CalendarEndpoint.RaceDateXMLKey] as! Date
                        jsonEvent[CalendarEndpoint.DateKey] = self.formatter.string(from: raceDate)
                        
                        jsonEvents[event.key] = jsonEvent
                    }
                    
                    jsonResponse[category.key] = jsonEvents
                }
                
                try response.setBody(json: jsonResponse)
            } catch {
                response.status = .internalServerError
                response.appendBody(string: "Error. Path is \(Dir.workingDir.path)")
            }
            response.completed()
        }
    }
}
