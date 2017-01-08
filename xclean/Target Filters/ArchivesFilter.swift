//
//  ArchivesFilter.swift
//  xclean
//
//  Created by Deszip on 08/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class ArchivesFilter: TargetFilter {
 
    private let entryBuilder: EntryBuilder
    
    init(entryBuilder: EntryBuilder) {
        self.entryBuilder = entryBuilder
    }
    
    func filter(_ entries: [Entry]) -> [Entry] {
        return entries.map { archiveDirectory -> [Entry] in
            self.entryBuilder.entriesAtURLs([archiveDirectory.url], onlyDirectories: false).filter({ archiveEntry -> Bool in
                return archiveEntry.url.pathExtension == "xcarchive"
            })
        }.flatMap { $0 }
         .sorted { (left, right) -> Bool in
            return left.size > right.size
        }
    }
    
}
