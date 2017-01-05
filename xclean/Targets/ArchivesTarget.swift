//
//  ArchivesTarget.swift
//  xclean
//
//  Created by Deszip on 05/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class ArchivesTarget: Target {
    
    let signature: TargetSignature
    let name: String = "Archives"
    
    var entries: [Entry] = []
    
    init() {
        self.signature = TargetSignature(type: TargetType.archives)
    }
    
    // MARK: - Target -

    func updateMetadata() {
        
    }
    
    func metadataDescription() -> String {
        return ""
    }
    
    func safeSize() -> Int64 {
        return 0
    }
    
    func clean() {
        
    }
}
