//
//  TargetCleaner.swift
//  xclean
//
//  Created by Deszip on 22/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

protocol TargetCleaner {

    init(fileManager: XCFileManager, urls: [URL], environment: Environment)

    func filterEntries(filter: TargetFilter) -> [Entry]
    func clean()
    func entriesDescription() -> String
    func entriesSize() -> Int64
}

class DefaultCleaner: TargetCleaner {
    
    private let fileManager: XCFileManager
    private var entries: [Entry]
    private let environment: Environment
    
    required init(fileManager: XCFileManager, urls: [URL], environment: Environment) {
        self.fileManager = fileManager
        self.entries = fileManager.entriesAtURLs(urls, onlyDirectories: true)
        self.environment = environment
        
        // Get timeout value
        var timeout: TimeInterval = 0
        environment.options.forEach { nextOption in
            switch nextOption {
                case .timeout(let timeoutValue): timeout = timeoutValue
                default: ()
            }
        }
        
        // Sort and filter
        self.entries = entries.filter { entry -> Bool in
            Date().timeIntervalSince(entry.accessDate) >= timeout
        }.map { entry in
            self.fileManager.fetchSize(entry: entry)
            return entry
        }.sorted { (left, right) -> Bool in
            return left.size > right.size
        }
    }
    
    func filterEntries(filter: TargetFilter) -> [Entry] {
        return filter.filter(entries)
    }
    
    func clean() {
        print("Clean: \(entries)")
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
        return entries.reduce(0, { $0 + $1.size } )
    }
    
}
