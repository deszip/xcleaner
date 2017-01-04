//
//  main.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation


func list() {
    let derivedData = DerivedDataTarget()
    derivedData.updateMetadata()
    print(derivedData.metadataDescription())
}

func remove(target: String) {
    print("Remove: \(target)")
}

func help() {
    
}

print("Args: \(CommandLine.arguments)")
let option = Option(options: CommandLine.arguments)
switch option {
    case .help : help()
    case .list : list()
    case .remove (let target) : remove(target: target)
}


