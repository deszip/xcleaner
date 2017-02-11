//
//  TargetCleaner.swift
//  xclean
//
//  Created by Deszip on 22/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

protocol TargetCleaner {
    
    init(fileManager: XCFileManager, urls: [URL])
    
    func processEntries(_ entries: [Entry]) -> [Entry]
    func clean()
    func entriesDescription() -> String
    func entriesSize() -> Int64
}

class DefaultCleaner: TargetCleaner {
    
    private let fileManager: XCFileManager
    private let entries: [Entry]
    
    required init(fileManager: XCFileManager, urls: [URL]) {
        self.fileManager = fileManager
        self.entries = fileManager.entriesAtURLs(urls, onlyDirectories: true)
    }
    
    func processEntries(_ entries: [Entry]) -> [Entry] {
        return entries
    }
    
    func clean() {
        
    }
    
    func entriesDescription() -> String {
        var description = ""
        if entries.count > 0 {
            var components: [[String]] = []
            for targetEntry in entries {
                components.append(targetEntry.metadataDescription())
            }
            
            description += Formatter.alignedStringComponents(components)
        }
        
        return description
    }
    
    func entriesSize() -> Int64 {
        return 0
    }
    
}
