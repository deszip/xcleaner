//
//  Cleaner.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Cleaner {
    
    private let environment: EnvironmentInteractor
    
    init(environment: EnvironmentInteractor) {
        self.environment = environment
    }
    
    func list(targetSignatures: [TargetSignature]) {
        var totalSize: Int64 = 0
        for target in buildTargets(targetSignatures: targetSignatures) {
            totalSize += target.safeSize()
            environment.stdout(target.metadataDescription())
        }
        
        let formattedSize = Formatter.formattedSize(totalSize)
        environment.stdout("Total XCode shit size: \(formattedSize)\n")
    }

    func remove(targetSignatures: [TargetSignature]) {
        var totalSize: Int64 = 0
        buildTargets(targetSignatures: targetSignatures).filter { $0.signature.removable }.forEach { target in
            totalSize += target.safeSize()
            target.clean()
        }
        
        let formattedSize = Formatter.formattedSize(totalSize)
        environment.stdout("Total cleaned: \(formattedSize)\n")
    }

    func buildTargets(targetSignatures: [TargetSignature]) -> [Target] {
        let fileManager = XCFileManager(fileManager: FileManager.default)
        
        return targetSignatures.filter({ $0.enabled }).map { signature -> Target in
            let target = Target(signature: signature, environment: environment)
            
            switch signature.type {
                case .archives:         target.filter = ArchivesFilter(fileManager: fileManager)
                case .deviceSupport:    target.filter = DeviceSupportFilter()
                case .coreSimulator:    target.cleaner = CoreSimulatorCleaner(fileManager: fileManager,
                                                                              urls: signature.urls,
                                                                              environment: environment)
                
                default: ()
            }
            
            return target
        }
    }
    
}
