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

    func clean()
    func entriesDescription() -> String
    func entriesSize() -> Int64
    
    var filter: TargetFilter? { get set }
    var entries: [Entry] { get }
}

class DefaultCleaner: TargetCleaner {
    
    internal var filter: TargetFilter?
    
    private let fileManager: XCFileManager
    private(set) var entries: [Entry]
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
    
    func clean() {
        print("Clean: \(filteredEntries())")
    }
    
    func entriesDescription() -> String {
        var description = ""
        
        if filteredEntries().count > 0 {
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
    
    private func filteredEntries() -> [Entry] {
        if let filter = self.filter {
            return filter.filter(self.entries)
        }
        
        return self.entries
    }
    
}
