//
//  Cleaner.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Cleaner {
    
    private let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    func list(targetSignatures: [TargetSignature]) {
        for target in buildTargets(targetSignatures: targetSignatures) {
            target.updateMetadata()
            environment.stdout(target.metadataDescription())
        }
    }

    func remove(targetSignatures: [TargetSignature]) {
        for target in buildTargets(targetSignatures: targetSignatures) {
            target.updateMetadata()
            target.clean()
        }
    }

    func buildTargets(targetSignatures: [TargetSignature]) -> [Target] {
        let inspector = Inspector(fileManager: FileManager.default)
        let entryBuilder = EntryBuilder(inspector: inspector)
        
        return targetSignatures.map { signature -> Target in
            switch signature.type {
            case .derivedData :     return DerivedDataTarget(entryBuilder: entryBuilder,
                                                             inspector: inspector,
                                                             environment: environment)
                case .archives :        return ArchivesTarget()
                case .deviceSupport:    return DeviceSupportTarget()
                case .coreSimulator:    return CoreSimulatorTarget()
                case .iphoneSimulator:  return IPhoneSimulatorTarget()
                case .xcodeCaches:      return XCodeCachesTarget()
                case .backup:           return BackupTarget()
                case .docSets:          return DocSetsTarget()
            }
        }
    }
    
}
