//
//  DerivedDataTarget.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class DerivedDataTarget: Target {
    
    private let outdatedTreshold: TimeInterval = 3600 * 48
    
    let signature: TargetSignature
    let name: String = "DerivedData"
    
    var entries: [Entry] = []
    
    init() {
        self.signature = TargetSignature(type: TargetType.derivedData)
    }
    
    // MARK: - Target -
    
    func updateMetadata() {
        entries = projectsList().sorted { (left, right) -> Bool in
            return left.size > right.size
        }
    }
    
    func metadataDescription() -> String {
        var description = "Total safe to remove: " + formattedSize(size: safeSize()) + "\n"
        for projectEntry in entries {
            description += (projectEntry.metadataDescription() + "\n")
        }
        
        return description
    }
    
    func safeSize() -> Int64 {
        return outdatedProjects().reduce(0, { (size, entry) in
            entry.size + size
        })
    }
    
    func clean() {
        outdatedProjects().forEach { entry in
            do {
                //try FileManager.default.removeItem(at: nextEntry.url)
                print("Removing: \(entry.url)\n")
            } catch {
                print("Unhandled error: \(error)")
            }
        }
    }
    
    // MARK: - Private -
    
    private func projectsList() -> [Entry] {
        // Flat all urls
        let files = signature.pathes.map { url -> [URL] in
            return try! FileManager.default.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: [URLResourceKey.contentModificationDateKey], options: [])
            }.flatMap { $0 }
        
        let filteredDirectories = files.filter { nextURL -> Bool in
            if nextURL.lastPathComponent == "ModuleCache" {
                return false
            }
            var isDirectory: ObjCBool = false
            FileManager.default.fileExists(atPath: nextURL.path, isDirectory: &isDirectory)
            return isDirectory.boolValue
        }
        
        return filteredDirectories.map { nextURL -> Entry in
            let entry = Entry(url: nextURL)
            entry.displayName = projectName(projectDirectoryName: nextURL.lastPathComponent)
            entry.size = sizeOfDirectory(url: nextURL)
            entry.formattedSize = formattedSize(size: entry.size)
            
            let attributes = try! FileManager.default.attributesOfItem(atPath: nextURL.path) as NSDictionary
            entry.accessDate = attributes.fileModificationDate() ?? Date()
            
            return entry
        }
    }
    
    private func sizeOfDirectory(url: URL) -> Int64 {
        guard let directoryEnumerator = FileManager.default.enumerator(at: url as URL,
                                                                   includingPropertiesForKeys: [URLResourceKey.fileSizeKey, URLResourceKey.nameKey],
                                                                   options: [.skipsHiddenFiles],
                                                                   errorHandler: nil) else { return 0 }
        
        var totalSize: Int64 = 0
        try! directoryEnumerator.allObjects.forEach({ nextURL in
            let attributes = try FileManager.default.attributesOfItem(atPath: (nextURL as! URL).path) as NSDictionary
            totalSize += attributes.fileSize().hashValue
        })
        
        return totalSize
    }
    
    private func formattedSize(size: Int64) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = .useAll
        byteCountFormatter.countStyle = .file
        let formattedSize = byteCountFormatter.string(fromByteCount: size)
        
        return formattedSize
    }
    
    private func projectName(projectDirectoryName: String) -> String {
        return projectDirectoryName.components(separatedBy: CharacterSet.init(charactersIn: "-"))[0]
    }
    
    private func outdatedProjects() -> [Entry] {
        let currentDate = Date()
        return entries.filter { currentDate.timeIntervalSince($0.accessDate) >= outdatedTreshold }
    }
    
}
