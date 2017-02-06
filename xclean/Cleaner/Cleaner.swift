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
        var totalSize: Int64 = 0
        for target in buildTargets(targetSignatures: targetSignatures) {
            target.updateMetadata()
            totalSize += target.safeSize()
            environment.stdout(target.metadataDescription())
        }
        
        let formattedSize = Formatter.formattedSize(totalSize)
        environment.stdout("Total XCode shit size: \(formattedSize)\n")
    }

    func remove(targetSignatures: [TargetSignature]) {
        var totalSize: Int64 = 0
        buildTargets(targetSignatures: targetSignatures).filter { $0.signature.removable }.forEach { target in
            target.updateMetadata()
            totalSize += target.safeSize()
            target.clean()
        }
        
        let formattedSize = Formatter.formattedSize(totalSize)
        environment.stdout("Total cleaned: \(formattedSize)\n")
    }

    func buildTargets(targetSignatures: [TargetSignature]) -> [Target] {
        let fileManager = XCFileManager(fileManager: FileManager.default)
        
        return targetSignatures.filter({ $0.enabled }).map { signature -> Target in
            let target = Target(signature: signature, fileManager: fileManager, environment: environment)
            
            switch signature.type {
                case .archives:         target.filter = ArchivesFilter(fileManager: fileManager)
                case .deviceSupport:    target.filter = DeviceSupportFilter()
                case .coreSimulator:
                    var appCleanTimeout: TimeInterval = 3600 * 24
                    var appPattern: String? = nil
                    environment.options.forEach { nextOption in
                        switch nextOption {
                            case .timeout(let timeout): appCleanTimeout = timeout
                            case .pattern(let pattern): appPattern = pattern
                            
                            default: ()
                        }
                    }

                    target.cleaner = CoreSimulatorCleaner(fileManager: fileManager, timeout: appCleanTimeout, appName: appPattern)
                
                default: ()
            }
            
            return target
        }
    }
    
}
