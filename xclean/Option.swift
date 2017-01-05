//
//  Option.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

enum Option: Equatable {
    case help
    case list(TargetType)
    case remove(TargetType)
    case undefined

    init(option: String, value: String? = nil) {
        switch option {
            case "h": self = .help
            case "l": self = .list(Option.typeForTarget(target: value))
            case "r": self = .remove(Option.typeForTarget(target: value))
            
            default: self = .undefined
        }
    }
    
    private static func typeForTarget(target: String?) -> TargetType {
        guard let target = target else {
            return TargetType.all
        }
        
        switch target {
            case "DerivedData" : return TargetType.derivedData
            case "Archives" : return TargetType.archives
            case "DeviceSupport" : return TargetType.deviceSupport
            case "CoreSimulator" : return TargetType.coreSimulator
            case "iPhoneSimulator" : return TargetType.iphoneSimulator
            case "XCodeCaches" : return TargetType.xcodeCaches
            case "Backup" : return TargetType.backup
            case "RootCoreSimulator" : return TargetType.rootCoreSimulator
            case "DocSets" : return TargetType.docSets
            
            default : return TargetType.all
        }
    }
}

func ==(lhs: Option, rhs: Option) -> Bool {
    switch (lhs, rhs) {
        case (.help, .help) : return true
        case (.undefined, .undefined) : return true
        case (.list(let a), .list(let b)) where a == b: return true
        case (.remove(let a), .remove(let b)) where a == b: return true
        default: return false
    }
}

class OptionsParser {
    
    var options: [Option] = []
    
    func parse(arguments: [String]) {
        if arguments.count == 0 {
            return
        }
        
        var pairs = arguments.joined(separator: " ").components(separatedBy: " -")
        if pairs.count > 1 {
            pairs.remove(at: 0)
        }
        
        pairs.forEach { nextPair in
            let chunks = nextPair.components(separatedBy: " ")
            let option = chunks[0].trimmingCharacters(in: CharacterSet(charactersIn: "-"))
            if chunks.count > 1 {
                options.append(Option(option: option, value: chunks[1]))
            } else {
                options.append(Option(option: option))
            }
        }
    }
    
    
}

