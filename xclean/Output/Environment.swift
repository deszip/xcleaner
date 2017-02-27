//
//  Environment.swift
//  xclean
//
//  Created by Deszip on 07/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

protocol EnvironmentInteractor {
    func stdout(_ string: String)
    func stderr(_ string: String)
    func terminate(success: Bool)
    
    var options: [Option] { get }
}

class Environment: EnvironmentInteractor {
    
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

}
