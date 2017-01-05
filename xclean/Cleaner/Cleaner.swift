//
//  Cleaner.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Cleaner {
    
    func list(targetSignatures: [TargetSignature]) {
        for target in buildTargets(targetSignatures: targetSignatures) {
            target.updateMetadata()
            print("Target: \(target.name))\n")
            print(target.metadataDescription())
        }
    }

    func remove(targetSignatures: [TargetSignature]) {
        for target in buildTargets(targetSignatures: targetSignatures) {
            target.updateMetadata()
            print(target.clean())
        }
    }

    func buildTargets(targetSignatures: [TargetSignature]) -> [Target] {
        return targetSignatures.map { signature -> Target in
            switch signature.type {
                case .derivedData :     return DerivedDataTarget()
                case .archives :        return ArchivesTarget()
                case .deviceSupport:    return DeviceSupportTarget()
                case .coreSimulator:    return CoreSimulatorTarget()
                case .iphoneSimulator:  return IPhoneSimulatorTarget()
                case .xcodeCaches:      return XCodeCachesTarget()
                case .backup:           return BackupTarget()
                case .docSets:          return DocSetsTarget()
                
                default: exit(EXIT_FAILURE)
            }
        }
    }
    
}
