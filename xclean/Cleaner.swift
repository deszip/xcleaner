//
//  Cleaner.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Cleaner {
    
    func list(targetTypes: [TargetType]) {
        for target in buildTargets(targetTypes: targetTypes) {
            target.updateMetadata()
            print("Target: \(target.name)\n")
            print(target.metadataDescription())
        }
    }

    func remove(targetTypes: [TargetType]) {
        for target in buildTargets(targetTypes: targetTypes) {
            target.updateMetadata()
            print(target.clean())
        }
    }

    func buildTargets(targetTypes: [TargetType]) -> [Target] {
        return targetTypes.map { type -> Target in
            switch type {
                case .derivedData : return DerivedDataTarget()
                default: exit(EXIT_FAILURE)
            }
        }
    }
    
}
