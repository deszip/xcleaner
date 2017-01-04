//
//  Option.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

enum Option {
    case help
    case list
    case remove(String)
    
    init(options: [String]) {
        switch options[1] {
            case "-h", "--help":    self = .help
            case "-l", "--list":    self = .list
            case "-r", "--remove":
                if options.count > 2 {
                    self = .remove(options[2])
                } else {
                    self = .help
                }

            default:                self = .help
        }
    }
}

