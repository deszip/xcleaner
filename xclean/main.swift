//
//  main.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

let cleaner = Cleaner()

// MARK: - Processing input -

func help() {
    //...
}

let parser = OptionsParser()
parser.parse(arguments: CommandLine.arguments)

if parser.options.contains(Option.help) {
    help()
    exit(EXIT_SUCCESS)
}

parser.options.forEach { nextOption in
    switch nextOption {
        case .list(let signatures): cleaner.list(targetSignatures: signatures)
        case .remove(let signatures): cleaner.remove(targetSignatures: signatures)
        
        default: help()
    }
}

exit(EXIT_SUCCESS)
