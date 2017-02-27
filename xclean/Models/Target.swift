//
//  Target.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Target {

    let environment: EnvironmentInteractor
    let signature: TargetSignature
    
    var entries: [Entry] {
        get {
            return self.cleaner.entries
        }
    }
    
    var filter: TargetFilter? {
        willSet {
            self.cleaner.filter = newValue
        }
    }
    var cleaner: TargetCleaner
    
    init(signature: TargetSignature, environment: EnvironmentInteractor, cleaner: TargetCleaner? = nil) {
        if let customCleaner = cleaner {
            self.cleaner = customCleaner
        } else {
            self.cleaner = DefaultCleaner(fileManager: XCFileManager(fileManager: FileManager.default),
                                          urls: signature.urls,
                                          environment: environment)
        }
        
        self.signature = signature
        self.environment = environment
    }
    
    func metadataDescription() -> String {
        // Basic description, does not deal with entries
        let totalSize = safeSize()
        var description = signature.type.name() + " total: " + Formatter.formattedSize(totalSize) + "\n"
        description += "Paths:\n\(signature.urls.map({ "\t" + $0.path }).joined(separator: "\n"))"
        description += "\n\n"
        
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
