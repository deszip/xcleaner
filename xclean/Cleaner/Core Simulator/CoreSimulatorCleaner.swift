//
//  CoreSimulatorCleaner.swift
//  xclean
//
//  Created by Deszip on 22/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class CoreSimulatorCleaner: TargetCleaner {
    internal var entries: [Entry] {
        get {
            return self.appsEntries
        }
    }
    internal var filter: TargetFilter?

    private let fileManager: XCFileManager
    private let environment: EnvironmentInteractor
    private let simulatorController: SimulatorController
    private let appsAnalyzer: SimulatorAppsAnalyzer
    
    private var targetEntries: [Entry] = []
    private var appsEntries: [Entry] = []
    
    required init(fileManager: XCFileManager, urls: [URL], environment: EnvironmentInteractor) {
        self.fileManager = fileManager
        self.environment = environment
        self.simulatorController = SimulatorController()
        self.appsAnalyzer = SimulatorAppsAnalyzer(fileManager: fileManager)
        
        // Get options from environemnt
        self.appsAnalyzer.appCleanTimeout = TimeInterval(environment.timeoutOption.value ?? 0)
        self.appsAnalyzer.appName = environment.appOption.value ?? nil
        
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
        var description = "Found \(simulatorController.unavailableSimulatorHashes().count) unavailable simulators\n\n"
        
        if appsEntries.count > 0 {
            var components: [[String]] = []
            for appEntry in appsEntries {
                components.append(appEntry.metadataDescription())
            }
            
            description += Formatter.alignedStringComponents(components)
            description += "\n\n"
        }
        
        return description
    }
    
    func entriesSize() -> Int64 {
        let appsSize = appsEntries.reduce(0, { $0 + $1.size } )
        return Int64((16 * 1024 * 1024) * simulatorController.unavailableSimulatorHashes().count) + appsSize
    }
    
    func clean() {
        removeUnavailable()
        removeApps()
    }
    
    // MARK: - Private -
    
    private func removeUnavailable() {
        simulatorController.cleanUnavailable()
    }
    
    private func removeApps() {
        print("Removing: \(appsEntries)")
        //appsEntries.forEach { self.fileManager.removeEntry($0) }
    }
    
    
    
}
