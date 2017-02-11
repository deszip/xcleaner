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
    private let simulatorValidator: SimulatorValidator
    private let appsAnalyzer: SimulatorAppsAnalyzer
    
    private var targetEntries: [Entry] = []
    private var appsEntries: [Entry] = []
    
    init(fileManager: XCFileManager, urls: [URL], timeout: TimeInterval = 0, appName: String? = nil) {
        self.fileManager = fileManager
        self.simulatorValidator = SimulatorValidator()
        self.appsAnalyzer = SimulatorAppsAnalyzer(fileManager: fileManager, timeout: timeout, appName: appName)
    }
    
    init(fileManager: XCFileManager, timeout: TimeInterval = 0, appName: String? = nil) {
        self.fileManager = fileManager
        self.simulatorValidator = SimulatorValidator()
        self.appsAnalyzer = SimulatorAppsAnalyzer(fileManager: fileManager, timeout: timeout, appName: appName)
    }
    
    // MARK: - TargetCleaner -
    
    func processEntries(_ entries: [Entry]) -> [Entry] {
        targetEntries = entries
        appsEntries = appsAnalyzer.outdatedApps(simulatorEntries: entries)
        
        let unavailableHashes = simulatorValidator.unavailableSimulatorHashes()
        let unavailableSimulators = entries.filter { unavailableHashes.contains($0.url.lastPathComponent) }
        
        return unavailableSimulators + appsEntries
    }
    
    func entriesDescription() -> String {
        return "Found \(simulatorValidator.unavailableSimulatorHashes().count) unavailable simulators\n\n"
    }
    
    func entriesSize() -> Int64 {
        return Int64((16 * 1024 * 1024) * simulatorValidator.unavailableSimulatorHashes().count)
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
        //appsEntries.forEach { self.fileManager.removeEntry($0) }
    }
    
    
    
}
