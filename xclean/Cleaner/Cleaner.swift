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
    private let targetBuilder: TargetBuilder
    
    init(environment: EnvironmentInteractor) {
        self.environment = environment
        self.targetBuilder = TargetBuilder(environment: environment)
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

    private func buildTargets(targetSignatures: [TargetSignature]) -> [Target] {
        return targetBuilder.buildTargets(targetSignatures: targetSignatures)
    }
    
}
