//
//  ArchivesFilter.swift
//  xclean
//
//  Created by Deszip on 08/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class ArchivesFilter: TargetFilter {
 
    private let fileManager: XCFileManager
    
    init(fileManager: XCFileManager) {
        self.fileManager = fileManager
    }
    
    func filter(_ entries: [Entry]) -> [Entry] {
        // Build entries for each archive
        let entries = entries.map { archiveDirectory -> [Entry] in
            self.fileManager.entriesAtURLs([archiveDirectory.url], onlyDirectories: false).filter({ archiveEntry -> Bool in
                return archiveEntry.url.pathExtension == "xcarchive"
            })
        }.flatMap { $0 }

        // Fetch size for archives
        entries.forEach { self.fileManager.fetchSize(entry: $0) }
        
        // Sort by size
        return entries.sorted { (left, right) -> Bool in
            return left.size > right.size
        }
    }
    
}
