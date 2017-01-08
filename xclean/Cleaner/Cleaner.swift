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
            case .derivedData :     return DerivedDataTarget(signature: signature,
                                                             entryBuilder: entryBuilder,
                                                             inspector: inspector,
                                                             environment: environment)
            case .archives :        return ArchivesTarget(signature: signature,
                                                          entryBuilder: entryBuilder,
                                                          inspector: inspector,
                                                          environment: environment)
            case .deviceSupport:    return DeviceSupportTarget(signature: signature,
                                                               entryBuilder: entryBuilder,
                                                               inspector: inspector,
                                                               environment: environment)
            case .coreSimulator:    return CoreSimulatorTarget(signature: signature,
                                                               entryBuilder: entryBuilder,
                                                               inspector: inspector,
                                                               environment: environment)
            case .iphoneSimulator:  return IPhoneSimulatorTarget(signature: signature,
                                                                 entryBuilder: entryBuilder,
                                                                 inspector: inspector,
                                                                 environment: environment)
            case .xcodeCaches:      return XCodeCachesTarget(signature: signature,
                                                             entryBuilder: entryBuilder,
                                                             inspector: inspector,
                                                             environment: environment)
            case .backup:           return BackupTarget(signature: signature,
                                                        entryBuilder: entryBuilder,
                                                        inspector: inspector,
                                                        environment: environment)
            case .docSets:          return DocSetsTarget(signature: signature,
                                                         entryBuilder: entryBuilder,
                                                         inspector: inspector,
                                                         environment: environment)
            }
        }
    }
    
}
