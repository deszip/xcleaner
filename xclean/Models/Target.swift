//
//  Target.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Target {
    // TODO: Set treshold from environmet options
    private let outdatedTreshold: TimeInterval = 0
    
    let entryBuilder: EntryBuilder
    let inspector: Inspector
    let environment: Environment
    let signature: TargetSignature
    
    var filter: TargetFilter?
    var entries: [Entry] = []
    
    init(signature: TargetSignature, entryBuilder: EntryBuilder, inspector: Inspector, environment: Environment) {
        self.signature = signature
        self.entryBuilder = entryBuilder
        self.inspector = inspector
        self.environment = environment
    }
    
    func updateMetadata() {
        // Get entries
        entries = entryBuilder.entriesAtURLs(signature.urls, onlyDirectories: true)
        
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
        var description = signature.type.name() + " total: " + Formatter.formattedSize(safeSize()) + "\n"
        description += "Pathes:\n\(signature.urls.map({ $0.path }).joined(separator: "\n"))"
        description += "\n\n"
        
        var components: [[String]] = []
        for projectEntry in entries {
            components.append(projectEntry.metadataDescription())
        }
        
        description += Formatter.alignedStringComponents(components)
        
        return description
    }
    
    func safeSize() -> Int64 {
        return entries.filter({ entryIsSafeToRemove($0) }).reduce(0, { (size, entry) in
            entry.size + size
        })
    }
    
    func clean() {
        entries.forEach { entry in
            if entryIsSafeToRemove(entry) {
                do {
                    //try inspector.fileManager.removeItem(at: nextEntry.url)
                    environment.stdout("Removing: \(entry.url.path)\n")
                } catch {
                    environment.stderr("Unhandled error: \(error)")
                }
            }
        }
    }
    
    func entryIsSafeToRemove(_ entry: Entry) -> Bool {
        return Date().timeIntervalSince(entry.accessDate) >= outdatedTreshold
    }
}
