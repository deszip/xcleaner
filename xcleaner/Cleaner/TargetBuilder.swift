//
//  TargetBuilder.swift
//  xclean
//
//  Created by Deszip on 09/04/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class TargetBuilder {
    
    private let environment: EnvironmentInteractor
    
    init(environment: EnvironmentInteractor) {
        self.environment = environment
    }
    
    func buildTargets(targetSignatures: [TargetSignature]) -> [Target] {
        return targetSignatures.filter({ $0.enabled }).map { signature -> Target in
            let target = Target(signature: signature, environment: environment)
            
            switch signature.type {
                case .archives:         target.filter = ArchivesFilter(fileManager: environment.fileManager)
                case .deviceSupport:    target.filter = DeviceSupportFilter()
                case .coreSimulator:    target.cleaner = CoreSimulatorCleaner(urls: signature.urls, environment: environment)
                    
                default: ()
            }
            
            return target
        }
    }

}
