//
//  Environment.swift
//  xclean
//
//  Created by Deszip on 07/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Environment {
    
    private let parser: OptionsParser
    private let stdoutHandle: FileHandle
    private let stderrHandle: FileHandle
    
    let options: [Option]
    
    init() {
        self.stdoutHandle = FileHandle.standardOutput
        self.stderrHandle = FileHandle.standardError
        
        self.parser = OptionsParser()
        parser.parse(arguments: CommandLine.arguments)
        self.options = parser.options
    }
    
    func stdout(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8) {
            stdoutHandle.write(data)
        }
    }
    
    func stdout(_ components: [String], padding: Int) {
        stdout(components.map { item -> String in
            item.padding(toLength: padding, withPad: " ", startingAt: item.lengthOfBytes(using: String.Encoding.utf8))
        }.joined(separator: ""))
    }
    
    func stderr(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8) {
            stderrHandle.write(data)
        }
    }
    
    func terminate(success: Bool = true) {
        if success {
            exit(EXIT_SUCCESS)
        }
        
        exit(EXIT_FAILURE)
    }
    
    func option(option: Option) -> Option? {
        let filtered = options.filter({ nextOption -> Bool in
            nextOption.test( { (testedOption) -> Bool in
                if case testedOption = option {
                    return true
                }
                return false
            })
        })
        
        if filtered.count > 0 {
            return filtered[0]
        }
        
        return nil
    }
 
}
