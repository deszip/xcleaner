//
//  CoreSimulatorCleaner.swift
//  xclean
//
//  Created by Deszip on 22/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class CoreSimulatorCleaner: TargetCleaner {
    
    private let inspector: Inspector
    private let entryBuilder: EntryBuilder
    
    init(inspector: Inspector, entryBuilder: EntryBuilder) {
        self.inspector = inspector
        self.entryBuilder = entryBuilder
    }
    
    // MARK: - TargetCleaner -
    
    func cleanerDescription(_ entries: [Entry]) -> String {
        return "Found \(unavailableSimulators()) unavailable simulators\nFound \(outdatedApps(simulatorEntries: entries).count) unused apps"
    }
    
    func cleanedSize() -> Int64 {
        return Int64((16 * 1024 * 1024) * unavailableSimulators())
    }
    
    func clean(_ entries: [Entry]) -> [Entry] {
        removeUnavailable()
        
        return outdatedApps(simulatorEntries: entries)
    }
    
    // MARK: - Private -
    
    private func removeUnavailable() {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["simctl", "remove", "unavailable"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        process.launch()

        /*
        let outputHandle = pipe.fileHandleForReading
        if let output = String(data: outputHandle.readDataToEndOfFile(), encoding: String.Encoding.utf8) {
            // TODO: get output for cleaner
        }
        */
    }
    
    private func unavailableSimulators() -> UInt64 {
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
            
            return UInt64(hashes.count)
        }
        
        return 0
    }
    
    private func outdatedApps(simulatorEntries: [Entry]) -> [Entry] {
        /*
         For each entry:
         - check that path data/Containers/Bundle/Application/ exists
         - get entries at that path - it's apps in simulator
         - filter outdated entries
            
            For each app entry:
            - open .com.apple.mobile_container_manager.metadata.plist
            - get value for MCMMetadataIdentifier - app bundle ID
            - get entries at data/Containers/Data/Application
            - find data entry with .com.apple.mobile_container_manager.metadata.plist -> MCMMetadataIdentifier matching app bundle ID
            - add app entry and data entry to the list
         */
        
        var apps: [Entry] = []
        
        simulatorEntries.forEach { simulatorEntry in
            let appURL = simulatorEntry.url.appendingPathComponent("/data/Containers/Bundle/Application/")
            if inspector.fileManager.fileExists(atPath: appURL.path) {
                let appEntries = entryBuilder.entriesAtURLs([appURL], onlyDirectories: true).filter { appEntry -> Bool in
                    Date().timeIntervalSince(appEntry.accessDate) >= 3600 * 24
                }
                
                apps.append(contentsOf: appEntries)
            }
        }
        
        return apps
    }
    
}
