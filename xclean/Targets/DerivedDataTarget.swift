//
//  DerivedDataTarget.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class DerivedDataTarget: Target {
    
    private let outdatedTreshold: TimeInterval = 0
    
    private let entryBuilder: EntryBuilder
    private let inspector: Inspector
    private let environment: Environment
    
    let signature: TargetSignature
    let name: String = "DerivedData"
    var entries: [Entry] = []
    
    init(entryBuilder: EntryBuilder, inspector: Inspector, environment: Environment) {
        self.entryBuilder = entryBuilder
        self.inspector = inspector
        self.environment = environment
        self.signature = TargetSignature(type: TargetType.derivedData)
    }
    
    // MARK: - Target -
    
    func updateMetadata() {
        entries = projectsList().sorted { (left, right) -> Bool in
            return left.size > right.size
        }
    }
    
    func metadataDescription() -> String {
        var description = "DerivedData total: " + Formatter.formattedSize(size: safeSize()) + "\n\n"
        var components: [[String]] = []
        for projectEntry in entries {
            //description += Formatter.alignedStringComponents(projectEntry.metadataDescription(), padding: 10)
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
    
    // MARK: - Private -
    
    private func projectsList() -> [Entry] {
        return entryBuilder.entriesAtURLs(signature.urls, onlyDirectories: true)
    }
    
    private func projectName(projectDirectoryName: String) -> String {
        return projectDirectoryName.components(separatedBy: "-")[0]
    }
    
    private func entryIsSafeToRemove(_ entry: Entry) -> Bool {
        return Date().timeIntervalSince(entry.accessDate) >= outdatedTreshold
    }
    
}
