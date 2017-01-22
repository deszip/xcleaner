//
//  CoreSimulatorCleaner.swift
//  xclean
//
//  Created by Deszip on 22/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class CoreSimulatorCleaner: TargetCleaner {
    
    func clean(_ entries: [Entry]) -> [Entry] {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["simctl", "remove", "unavailable"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()
        
        let outputHandle = pipe.fileHandleForReading
        if let output = String(data: outputHandle.readDataToEndOfFile(), encoding: String.Encoding.utf8) {
            // TODO: get output for cleaner
        }
        
        return []
    }
    
}
