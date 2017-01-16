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
    case version
    case list([TargetSignature])
    case remove([TargetSignature])
    case timeout(TimeInterval)
    case undefined

    init(option: String, value: String? = nil) {
        switch option {
            case "h": self = .help
            case "v": self = .version
            case "l": self = .list(Option.signaturesForTarget(target: value))
            case "r": self = .remove(Option.signaturesForTarget(target: value))
            case "t": self = .timeout(Double(value ?? "0") ?? 0)
            
            default: self = .undefined
        }
    }
    
    private static func signaturesForTarget(target: String?) -> [TargetSignature] {
        guard let target = target else {
            return TargetSignature.all()
        }
        
        switch target {
            case "DerivedData" : return [TargetSignature(type: TargetType.derivedData)]
            case "Archives" : return [TargetSignature(type: TargetType.archives)]
            case "DeviceSupport" : return [TargetSignature(type: TargetType.deviceSupport)]
            case "CoreSimulator" : return [TargetSignature(type: TargetType.coreSimulator)]
            case "iPhoneSimulator" : return [TargetSignature(type: TargetType.iphoneSimulator)]
            case "XCodeCaches" : return [TargetSignature(type: TargetType.xcodeCaches)]
            
            default : return TargetSignature.all()
        }
    }
}

func ==(lhs: Option, rhs: Option) -> Bool {
    switch (lhs, rhs) {
        case (.help, .help) : return true
        case (.version, .version) : return true
        case (.undefined, .undefined) : return true
        case (.list(let a), .list(let b)) where a == b: return true
        case (.remove(let a), .remove(let b)) where a == b: return true
        case (.timeout(let a), .timeout(let b)) where a == b: return true
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

