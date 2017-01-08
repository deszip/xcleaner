//
//  ArchivesTarget.swift
//  xclean
//
//  Created by Deszip on 05/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class ArchivesTarget: Target {
    
    // MARK: - Target -

    override func updateMetadata() {
        entries = archivesList()
    }
    
    // MARK: - Private -
    
    private func archivesList() -> [Entry] {
        return entryBuilder.entriesAtURLs(signature.urls, onlyDirectories: true).map { archiveDirectory -> [Entry] in
            self.entryBuilder.entriesAtURLs([archiveDirectory.url], onlyDirectories: false).filter({ archiveEntry -> Bool in
                return archiveEntry.url.pathExtension == "xcarchive"
            })
        }.flatMap { $0 }
         .sorted { (left, right) -> Bool in
            return left.size > right.size
        }
    }

}
