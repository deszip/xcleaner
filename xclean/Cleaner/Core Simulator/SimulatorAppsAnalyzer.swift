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
    
    func outdatedApps(simulatorEntries: [Entry]) -> [Entry] {
        /*
         For each entry:
         + check that path data/Containers/Bundle/Application/ exists
         + get entries at that path - it's apps in simulator
         + filter outdated entries
         - set display name for entry to app name
         
             For each app entry:
             - open .com.apple.mobile_container_manager.metadata.plist
             - get value for MCMMetadataIdentifier - app bundle ID
             - get entries at data/Containers/Data/Application
             - find data entry with .com.apple.mobile_container_manager.metadata.plist -> MCMMetadataIdentifier matching app bundle ID
             - add app entry and data entry to the list
         */
        
        var apps: [Entry] = []
        var documentEntries: [Entry] = []
        
        simulatorEntries.forEach { simulatorEntry in
            let appURL = simulatorEntry.url.appendingPathComponent("/data/Containers/Bundle/Application/")
            if fileManager.fileExists(atURL: appURL) {
                let appEntries = fileManager.entriesAtURLs([appURL], onlyDirectories: true).filter {
                    Date().timeIntervalSince($0.accessDate) >= 3600 * 24
                }
                
                appEntries.forEach { appEntry in
                    appEntry.displayName = appDisplayName(appEntry)
                    
                    // Get bundle ID
                    let infoPlistURL = appEntry.url.appendingPathComponent("/.com.apple.mobile_container_manager.metadata.plist")
                    if let appInfo = NSDictionary(contentsOf: infoPlistURL),
                       let bundleID = appInfo["MCMMetadataIdentifier"] as? String,
                       let documentEntry = documentsEntryForApp(_appEntry: appEntry, bundleID: bundleID) {
                        documentEntries.append(documentEntry)
                    }
                }
                
                apps.append(contentsOf: appEntries)
            }
        }
        
        return apps + documentEntries
    }
    
    private func appDisplayName(_ entry: Entry) -> String {
        return entry.url.lastPathComponent
    }
    
    private func documentsEntryForApp(_appEntry: Entry, bundleID: String) -> Entry? {
        return nil
    }
    
} 
