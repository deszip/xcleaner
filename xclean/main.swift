//
//  main.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

// MARK: - Processing input -

func help() {
    print("Help...")
}

let environment = Environment()

if environment.options.contains(Option.help) {
    help()
    environment.terminate()
}

let cleaner = Cleaner(environment: environment)

environment.options.forEach { nextOption in
    switch nextOption {
        case .list(let signatures): cleaner.list(targetSignatures: signatures)
        case .remove(let signatures): cleaner.remove(targetSignatures: signatures)
        
        default: help()
    }
}

environment.terminate()
