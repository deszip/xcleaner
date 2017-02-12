//
//  Target.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Target {

    let fileManager: XCFileManager
    let environment: Environment
    let signature: TargetSignature
    
    var filter: TargetFilter? {
        willSet {
            if let newFilter = newValue {
                self.entries = self.cleaner.filterEntries(filter: newFilter)
            }
        }
    }
    
    var cleaner: TargetCleaner
    var entries: [Entry] = []
    
    init(signature: TargetSignature, fileManager: XCFileManager, environment: Environment) {
        self.cleaner = DefaultCleaner(fileManager: fileManager, urls: signature.urls, environment: environment)
        
        self.signature = signature
        self.fileManager = fileManager
        self.environment = environment
    }
    
    func metadataDescription() -> String {
        // Basic description
        let totalSize = safeSize()
        var description = signature.type.name() + " total: " + Formatter.formattedSize(totalSize) + "\n"
        description += "Paths:\n\(signature.urls.map({ "\t" + $0.path }).joined(separator: "\n"))"
        description += "\n\n"
        
        // Check if we have entries to clean
        /*
        if entries.count > 0 {
            var components: [[String]] = []
            for targetEntry in entries {
                components.append(targetEntry.metadataDescription())
            }
            
            description += Formatter.alignedStringComponents(components)
        }
        */
        
        // Check if custom cleaner wants to clean something
        if cleaner.entriesSize() > 0 {
            description += "\n" + cleaner.entriesDescription() + "\n"
        }
        
        // If nothing to clean
        if totalSize == 0 {
            description += "All clean. Nothing to remove.\n\n"
        }
        
        return description
    }
    
    func safeSize() -> Int64 {
        return cleaner.entriesSize()
    }
    
    func clean() {
        cleaner.clean()
    }

}
