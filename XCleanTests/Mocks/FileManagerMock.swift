//
//  FileManagerMock.swift
//  xclean
//
//  Created by Deszip on 26/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class FileManagerMock: XCFileManager {
    
    var stubbedURLs: [URL: Int64] = [:]
    
    override func sizeOfDirectory(url: URL) -> Int64 { return 0 }
    
    override func fileExists(atURL url: URL) -> Bool { return true }
    
    override func removeEntry(_ entry: Entry) { }
    
    override func entriesAtURLs(_ urls: [URL], onlyDirectories: Bool) -> [Entry] {
        return stubbedURLs.map({ (url, size) -> Entry in
            let entry = Entry(url: url)
            entry.size = size
            entry.accessDate = Date()
            
            return entry
        })
    }
    
    override func fetchSize(entry: Entry) { }
}
