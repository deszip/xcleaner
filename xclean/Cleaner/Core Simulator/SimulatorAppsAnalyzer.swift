//
//  SimulatorAppsAnalyzer.swift
//  xclean
//
//  Created by Deszip on 05/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class SimulatorAppsAnalyzer {
    
    private let fileManager: XCFileManager
    
    init(fileManager: XCFileManager) {
        self.fileManager = fileManager
    }
    
    func outdatedApps(simulatorEntries: [Entry], timeout: TimeInterval = 0, appName: String? = nil) -> [Entry] {
        var apps: [Entry] = []
        var documentEntries: [Entry] = []
        
        // Iterate simulators
        simulatorEntries.forEach { simulatorEntry in
            let appsURL = simulatorEntry.url.appendingPathComponent("/data/Containers/Bundle/Application/")
            if fileManager.fileExists(atURL: appsURL) {
                // Filter apps
                let appEntries = filter(applications(atURL: appsURL), timeout: timeout, appName: appName)
                
                // Iterate filtered apps in simulator, check for app data
                appEntries.forEach { appEntry in
                    let bundleID = appBundleID(appEntry)
                    documentEntries.append(contentsOf: documentEntriesForSimulator(simulatorEntry, bundleID: bundleID))
                }
                
                apps.append(contentsOf: appEntries)
            }
        }
        
        return apps + documentEntries
    }
    
    // MARK: - Tools -
    
    private func applications(atURL url: URL) -> [Entry] {
        let appEntries =  fileManager.entriesAtURLs([url], onlyDirectories: true)
        appEntries.forEach { $0.displayName = appDisplayName($0) }
        
        return appEntries
    }
    
    private func filter(_ entries: [Entry], timeout: TimeInterval = 0, appName: String? = nil) -> [Entry] {
        return entries.filter { entry -> Bool in
            let outdated = Date().timeIntervalSince(entry.accessDate) >= timeout
            var nameMatch = true
            if appName != nil {
                nameMatch = entry.displayName == appName
            }
            
            return outdated && nameMatch
        }
    }
    
    private func appDisplayName(_ entry: Entry) -> String {
        let appEntries = fileManager.entriesAtURLs([entry.url], onlyDirectories: false).filter { nextEntry -> Bool in
            nextEntry.url.pathExtension == "app"
        }
        
        if appEntries.count > 0 {
            return appEntries[0].url.deletingPathExtension().lastPathComponent
        }
        
        return entry.url.lastPathComponent
    }
    
    private func appBundleID(_ entry: Entry) -> String {
        let infoPlistURL = entry.url.appendingPathComponent("/.com.apple.mobile_container_manager.metadata.plist")
        if let appInfo = NSDictionary(contentsOf: infoPlistURL),
            let bundleID = appInfo["MCMMetadataIdentifier"] as? String {
            return bundleID
        }
        
        return "unknown"
    }
    
    private func documentEntriesForSimulator(_ simEntry: Entry, bundleID: String) -> [Entry] {
        let dataURL = simEntry.url.appendingPathComponent("data/Containers/Data/Application/")
        let dataEntries = fileManager.entriesAtURLs([dataURL], onlyDirectories: true).filter { appBundleID($0) == bundleID }
        dataEntries.forEach { dataEntry in
            dataEntry.displayName = "\(bundleID) data"
        }
        
        return dataEntries
    }
    
} 
