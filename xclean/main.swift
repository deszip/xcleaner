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
    print(
        "usage: xclean [-l] <TARGET> [-r] <TARGET> [-t] <TIMEOUT>\n" +
        "Cleans some of the stuff created by XCode.\n" +
        "May corrupt or remove anything on your disc, you were warned :)\n\n" +
        
        "-l <TARGET>    Lists files that could be relatively safely removed.\n" +
        "               Pass target name to list only it. Available targets: DerivedData, Archives, DeviceSupport, CoreSimulator.\n" +
        "               If no value passed - uses all targets.\n" +
        "-r <TARGET>    Removes files listed by -l\n" +
        "-t <TIMEOUT>   Sets interval for assuming file is old.\n" +
        "               -r and -l will process only files with last access date older than timeout\n" +
        "-v             Print the version of the application\n"
    )
}

func version() {
    print("0.0.1")
}




let environment = Environment()

if environment.options.contains(Option.help) {
    help()
    environment.terminate()
}

if environment.options.contains(Option.version) {
    version()
    environment.terminate()
}

let cleaner = Cleaner(environment: environment)

environment.options.forEach { nextOption in
    switch nextOption {
        case .list(let signatures): cleaner.list(targetSignatures: signatures)
        case .remove(let signatures): cleaner.remove(targetSignatures: signatures)
        case .timeout(_): ()
        case .pattern(_): ()
        
        default: help()
    }
}

environment.terminate()
