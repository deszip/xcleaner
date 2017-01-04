//
//  Target.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

enum TargetType: String {
    case derivedData = "~/Library/Developer/Xcode/DerivedData"
    case archives
    case deviceSupport
    case coreSimulator
    case iphoneSimulator
    case xcodeCaches
    case backup
    case rootCoreSimulator
    case docSets
}

protocol Target {
    
    var type: TargetType { get }
    var url: NSURL { get }
    
    func updateMetadata()
    
    func metadataDescription() -> String
    func safeSize() -> UInt64
    func clean()
}
