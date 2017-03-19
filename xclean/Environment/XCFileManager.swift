//
//  XCFileManager.swift
//  xclean
//
//  Created by Deszip on 07/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class XCFileManager {
    
    let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    // MARK: - FS -
    
    func sizeOfDirectory(url: URL) -> Int64 {
        guard let directoryEnumerator = fileManager.enumerator(at: url as URL,
                                                                       includingPropertiesForKeys: [URLResourceKey.fileSizeKey, URLResourceKey.nameKey],
                                                                       options: [.skipsHiddenFiles],
                                                                       errorHandler: nil) else { return 0 }
        
        var totalSize: Int64 = 0
        try! directoryEnumerator.allObjects.forEach({ nextURL in
            let attributes = try fileManager.attributesOfItem(atPath: (nextURL as! URL).path) as NSDictionary
            totalSize += Int64(attributes.fileSize())
        })
        
        return totalSize
    }
    
    func fileExists(atURL url: URL) -> Bool {
        return fileManager.fileExists(atPath: url.path)
    }
    
    // MARK: - Entry -
    
    func removeEntry(_ entry: Entry) {
        do {
            try fileManager.removeItem(at: entry.url)
            //...
        } catch {
            //...
        }
    }
    
    func entriesAtURLs(_ urls: [URL], onlyDirectories: Bool) -> [Entry] {
        return urls.map { url -> [URL] in
            do {
                return try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.contentModificationDateKey], options: [])
            } catch {
                return []
            }
        }.flatMap { $0 }
        .filter { url -> Bool in
            if onlyDirectories {
                var isDirectory: ObjCBool = false
                fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
                return isDirectory.boolValue
            }
            return true
        }.map { entryForURL($0) }
    }
    
    func entryForURL(_ url: URL) -> Entry {
        let entry = Entry(url: url)
        entry.displayName = url.lastPathComponent
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: url.path) as NSDictionary
            entry.accessDate = attributes.fileModificationDate() ?? Date()
        } catch {
            // handle error...
        }
        
        return entry
    }
    
    func fetchSize(entry: Entry) {
        entry.size = sizeOfDirectory(url: entry.url)
        entry.formattedSize = Formatter.formattedSize(entry.size)
    }
    
}
