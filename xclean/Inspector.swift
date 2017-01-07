//
//  Inspector.swift
//  xclean
//
//  Created by Deszip on 07/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Inspector {
    
    let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func sizeOfDirectory(url: URL) -> Int64 {
        guard let directoryEnumerator = fileManager.enumerator(at: url as URL,
                                                                       includingPropertiesForKeys: [URLResourceKey.fileSizeKey, URLResourceKey.nameKey],
                                                                       options: [.skipsHiddenFiles],
                                                                       errorHandler: nil) else { return 0 }
        
        var totalSize: Int64 = 0
        try! directoryEnumerator.allObjects.forEach({ nextURL in
            let attributes = try fileManager.attributesOfItem(atPath: (nextURL as! URL).path) as NSDictionary
            totalSize += attributes.fileSize().hashValue
        })
        
        return totalSize
    }
    
}
