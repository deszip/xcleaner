//
//  TargetCleaner.swift
//  xclean
//
//  Created by Deszip on 22/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

protocol TargetCleaner {

    init(urls: [URL], environment: EnvironmentInteractor)

    func clean()
    func entriesDescription() -> String
    func entriesSize() -> Int64
    
    var filter: TargetFilter? { get set }
    var entries: [Entry] { get }
}

class DefaultCleaner: TargetCleaner {
    
    private static let DefaultTimeout = 3600
    
    internal var filter: TargetFilter? {
        didSet {
            if let newFilter = self.filter {
                self.entries = newFilter.filter(self.entries)
            }
        }
    }
    
    private(set) var entries: [Entry]
    private let environment: EnvironmentInteractor
    
    required init(urls: [URL], environment: EnvironmentInteractor) {
        self.entries = environment.fileManager.entriesAtURLs(urls, onlyDirectories: true)
        self.environment = environment
        
        // Sort and filter
        let timeout: TimeInterval = TimeInterval(environment.timeoutOption.value ?? DefaultCleaner.DefaultTimeout)
        self.entries = entries.filter { entry -> Bool in
            Date().timeIntervalSince(entry.accessDate) >= timeout
        }.map { entry in 
            self.environment.fileManager.fetchSize(entry: entry)
            return entry
        }.sorted { (left, right) -> Bool in
            return left.size > right.size
        }
    }
    
    func clean() {
        print("Clean: \(entries)")
        //entries.forEach { self.fileManager.removeEntry($0) }
    }
    
    func entriesDescription() -> String {
        var description = ""
        
        if entries.count > 0 {
            var components: [[String]] = []
            for targetEntry in entries {
                components.append(targetEntry.metadataDescription())
            }
            
            description += Formatter.alignedStringComponents(components)
            description += "\n\n"
        }
        
        return description
    }
    
    func entriesSize() -> Int64 {
        return entries.reduce(0, { $0 + $1.size } )
    }

}
