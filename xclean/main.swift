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
        case .list(let targetType): cleaner.list(targetTypes: [targetType])
        case .remove(let targetType): cleaner.remove(targetTypes: [targetType])
        
        default: help()
    }
}

exit(EXIT_SUCCESS)
