//
//  Entry.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Entry {
    
    private let dateFormatter = DateFormatter()
    let url: URL
    
    var size: Int64 = 0
    var formattedSize: String = ""
    var accessDate: Date = Date()
    var displayName: String
    
    init(url: URL) {
        self.url = url
        self.displayName = url.lastPathComponent
        
        self.dateFormatter.dateFormat = "dd.mm.yyyy hh:mm:ss"
    }
    
    func metadataDescription() -> [String] {
        return [displayName, formattedSize, dateFormatter.string(from: accessDate)]
    }
}
