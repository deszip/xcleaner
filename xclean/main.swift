//
//  main.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

let environment = Environment()
let cleaner = Cleaner(environment: environment)

if environment.helpOption.wasSet {
    environment.printUsage()
    environment.terminate()
}

if environment.versionOption.wasSet {
    environment.printVersion()
    environment.terminate()
}

if environment.listOption.wasSet {
    if let signatures = TargetSignature.signaturesForOption(environment.listOption) {
        cleaner.list(targetSignatures: signatures)
    } else {
        environment.printUsage()
    }
}

if environment.removeOption.wasSet {
    if let signatures = TargetSignature.signaturesForOption(environment.removeOption) {
        cleaner.remove(targetSignatures: signatures)
    } else {
        environment.printUsage()
    }
}

environment.terminate()
