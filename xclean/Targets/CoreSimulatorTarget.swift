//
//  CoreSimulatorTarget.swift
//  xclean
//
//  Created by Deszip on 05/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class CoreSimulatorTarget: Target {
    
    let signature: TargetSignature
    let name: String = "Core Simulator"
    
    var entries: [Entry] = []
    
    init() {
        self.signature = TargetSignature(type: TargetType.coreSimulator)
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
