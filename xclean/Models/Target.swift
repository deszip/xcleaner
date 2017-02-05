//
//  Target.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Target {
    private var outdatedTreshold: TimeInterval = 0
    
    let entryBuilder: EntryBuilder
    let inspector: Inspector
    let environment: Environment
    let signature: TargetSignature
    
    var filter: TargetFilter?
    var cleaner: TargetCleaner?
    var entries: [Entry] = []
    
    init(signature: TargetSignature, entryBuilder: EntryBuilder, inspector: Inspector, environment: Environment) {
        self.signature = signature
        self.entryBuilder = entryBuilder
        self.inspector = inspector
        self.environment = environment
        
        environment.options.forEach { nextOption in
            switch nextOption {
                case .timeout(let interval): self.outdatedTreshold = interval
                default: ()
            }
        }
    }
    
    func updateMetadata() {
        // Get entries
        entries = entryBuilder.entriesAtURLs(signature.urls, onlyDirectories: true).filter({ entryIsSafeToRemove($0) })
        
        // Apply filter
        if let filter = self.filter {
            entries = filter.filter(entries)
        }
        
        // Calculate sizes for filtered entries
        entries = entries.map { entry in
            self.entryBuilder.fetchSize(entry: entry)
            return entry
        }.sorted { (left, right) -> Bool in
            return left.size > right.size
        }
    }
    
    func metadataDescription() -> String {
        // Basic description
        let totalSize = safeSize()
        var description = signature.type.name() + " total: " + Formatter.formattedSize(totalSize) + "\n"
        description += "Paths:\n\(signature.urls.map({ "\t" + $0.path }).joined(separator: "\n"))"
        description += "\n\n"
        
        // Chack if we have entries to clean
        if entries.count > 0 {
            var components: [[String]] = []
            for projectEntry in entries {
                components.append(projectEntry.metadataDescription())
            }
            
            description += Formatter.alignedStringComponents(components)
        }
        
        // Check if custom cleaner wants to clean something
        if let cleaner = cleaner, cleaner.cleanedSize() > 0 {
            description += "\n" + cleaner.cleanerDescription() + "\n"
        }
        
        // If nothing to clean
        if totalSize == 0 {
            description += "All clean. Nothing to remove.\n\n"
        }
        
        return description
    }
    
    func safeSize() -> Int64 {
        var entriesSize = entries.reduce(0, { (size, entry) in
            entry.size + size
        })
        
        if let cleanerSize = cleaner?.cleanedSize() {
            entriesSize += cleanerSize
        }
        
        return entriesSize
    }
    
    func clean() {
        // Apply custom cleaner
        if let cleaner = self.cleaner {
            entries = cleaner.clean(entries)
        }
        
        entries.forEach { entry in
            do {
                try inspector.fileManager.removeItem(at: entry.url)
                environment.stdout("Removing: \(entry.url.path)\n")
            } catch {
                environment.stderr("Unhandled error: \(error)")
            }
        }
    }
    
    func entryIsSafeToRemove(_ entry: Entry) -> Bool {
        return Date().timeIntervalSince(entry.accessDate) >= outdatedTreshold
    }
}
