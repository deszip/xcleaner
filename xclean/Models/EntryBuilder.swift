//
//  EntryBuilder.swift
//  xclean
//
//  Created by Deszip on 07/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class EntryBuilder {
    
    private let inspector: Inspector
    
    init(inspector: Inspector) {
        self.inspector = inspector
    }
    
    func entriesAtURLs(_ urls: [URL], onlyDirectories: Bool) -> [Entry] {
        return urls.map { url -> [URL] in
            return try! inspector.fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.contentModificationDateKey], options: [])
            }.flatMap { $0 }
            .filter { url -> Bool in
                if onlyDirectories {
                    var isDirectory: ObjCBool = false
                    inspector.fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
                    return isDirectory.boolValue
                }
                
                return true
            }.map { entryForURL($0) }
    }
    
    func entryForURL(_ url: URL) -> Entry {
        let entry = Entry(url: url)
        entry.displayName = url.lastPathComponent
        
        let attributes = try! inspector.fileManager.attributesOfItem(atPath: url.path) as NSDictionary
        entry.accessDate = attributes.fileModificationDate() ?? Date()
        
        return entry
    }
    
    func fetchSize(entry: Entry) {
        entry.size = inspector.sizeOfDirectory(url: entry.url)
        entry.formattedSize = Formatter.formattedSize(entry.size)
    }
    
}
