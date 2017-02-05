//
//  SimulatorValidator.swift
//  xclean
//
//  Created by Deszip on 05/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class SimulatorValidator {
    
    func unavailableSimulatorHashes() -> [String] {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["simctl", "list"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        
        let outputHandle = pipe.fileHandleForReading
        if let output = String(data: outputHandle.readDataToEndOfFile(), encoding: String.Encoding.utf8)?.components(separatedBy: "\n") {
            var unavailable = false
            let hashes: [String] = output.reduce([], { (unavailableHashes, line) in
                
                // Start
                if line.hasPrefix("-- Unavailable:") {
                    unavailable = true
                    return unavailableHashes
                }
                
                // End
                if line.hasPrefix("==") {
                    unavailable = false
                    return unavailableHashes
                }
                
                if unavailable {
                    do {
                        let regex = try NSRegularExpression(pattern: "([a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12})")
                        let nsString = line as NSString
                        let results = regex.matches(in: line, range: NSRange(location: 0, length: nsString.length))
                        if let firstMatch = (results.map { nsString.substring(with: $0.range) }).first {
                            return unavailableHashes + [firstMatch]
                        }
                        
                        return unavailableHashes
                    } catch {
                        return unavailableHashes
                    }
                } else {
                    return unavailableHashes
                }
            })
            
            return hashes
        }
        
        return []
    }
    
}
