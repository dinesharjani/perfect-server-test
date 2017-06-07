//
//  NginxLogger.swift
//  PerfectServerTest
//
//  Created by Dinesh Harjani on 07/06/2017.
//
//

import Foundation
import PerfectLib

public class NginxLogger : NSObject {
    
    private let file: File
    
    public init(_ fileName: String) {
        self.file = File(fileName)
        super.init()
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
