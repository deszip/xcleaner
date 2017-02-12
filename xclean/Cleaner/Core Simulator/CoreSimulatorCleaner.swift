//
//  CoreSimulatorCleaner.swift
//  xclean
//
//  Created by Deszip on 22/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class CoreSimulatorCleaner: TargetCleaner {
    private let fileManager: XCFileManager
    private let environment: Environment
    private let simulatorValidator: SimulatorValidator
    private let appsAnalyzer: SimulatorAppsAnalyzer
    
    private var targetEntries: [Entry] = []
    private var appsEntries: [Entry] = []
    
    required init(fileManager: XCFileManager, urls: [URL], environment: Environment) {
        self.fileManager = fileManager
        self.environment = environment
        self.simulatorValidator = SimulatorValidator()
        self.appsAnalyzer = SimulatorAppsAnalyzer(fileManager: fileManager)
        
        // Get options from environemnt
        var timeout: TimeInterval = 0
        var appPattern: String? = nil

        environment.options.forEach { nextOption in
            switch nextOption {
                case .timeout(let timeoutValue): timeout = timeoutValue
                case .pattern(let pattern): appPattern = pattern
                default: ()
            }
        }
        
        self.appsAnalyzer.appCleanTimeout = timeout
        self.appsAnalyzer.appName = appPattern
        
        // Apps entries
        self.targetEntries = fileManager.entriesAtURLs(urls, onlyDirectories: true)
        self.appsEntries = appsAnalyzer.outdatedApps(simulatorEntries: targetEntries)
        self.appsEntries.forEach { self.fileManager.fetchSize(entry: $0) }
        self.appsEntries.sort { (left, right) -> Bool in
            left.size > right.size
        }
    }
    
    // MARK: - TargetCleaner -
    
    internal func filterEntries(filter: TargetFilter) -> [Entry] {
        return filter.filter(appsEntries)
    }
    
    func entriesDescription() -> String {
        var description = "Found \(simulatorValidator.unavailableSimulatorHashes().count) unavailable simulators\n\n"
        
        if appsEntries.count > 0 {
            var components: [[String]] = []
            for appEntry in appsEntries {
                components.append(appEntry.metadataDescription())
            }
            
            description += Formatter.alignedStringComponents(components)
        }
        
        return description
    }
    
    func entriesSize() -> Int64 {
        let appsSize = appsEntries.reduce(0, { $0 + $1.size } )
        return Int64((16 * 1024 * 1024) * simulatorValidator.unavailableSimulatorHashes().count) + appsSize
    }
    
    func clean() {
        removeUnavailable()
        removeApps()
    }
    
    // MARK: - Private -
    
    private func removeUnavailable() {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["simctl", "delete", "unavailable"]
        
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
    
    private func removeApps() {
        print("Removing: \(appsEntries)")
        //appsEntries.forEach { self.fileManager.removeEntry($0) }
    }
    
    
    
}
