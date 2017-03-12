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
    
    var listOption: MultiStringOption { get }
    var removeOption: MultiStringOption { get }
    var timeoutOption: IntOption { get }
    var appOption: StringOption { get }
    var helpOption: BoolOption { get }
    var versionOption: BoolOption { get }
}

class Environment: EnvironmentInteractor {
    
    private let stdoutHandle: FileHandle
    private let stderrHandle: FileHandle
    
    let listOption: MultiStringOption
    let removeOption: MultiStringOption
    let timeoutOption: IntOption
    let appOption: StringOption
    let helpOption: BoolOption
    let versionOption: BoolOption
    
    init() {
        self.stdoutHandle = FileHandle.standardOutput
        self.stderrHandle = FileHandle.standardError
        
        let cli = CommandLine()
        
        listOption = MultiStringOption(shortFlag: "l",
                                    longFlag: "list",
                                    helpMessage: "Lists target stats.")
        listOption.defaultValue = []
        
        removeOption = MultiStringOption(shortFlag: "r",
                                  longFlag: "remove",
                                  helpMessage: "Cleans targets.")
        removeOption.defaultValue = []
        
        timeoutOption = IntOption(shortFlag: "t",
                                  longFlag: "timeout",
                                  helpMessage: "Sets timeout.")
        
        appOption = StringOption(shortFlag: "a",
                                  longFlag: "app",
                                  helpMessage: "Sets app name.")
        
        
        helpOption = BoolOption(shortFlag: "h",
                              longFlag: "help",
                              helpMessage: "Prints a help message.")
        
        versionOption = BoolOption(shortFlag: "v",
                                      longFlag: "version",
                                      helpMessage: "Print app version.")
        
        cli.addOptions(listOption, removeOption, timeoutOption, appOption, helpOption, versionOption)
        
        do {
            try cli.parse()
            
            // Debug
            print("List: \(listOption.value)")
            print("Remove: \(removeOption.value)")
            print("Timeout: \(timeoutOption.value)")
            print("App: \(appOption.value)")
            
            print("Help: \(helpOption.value)")
            print("Version: \(versionOption.value)")
            
        } catch {
            cli.printUsage(error)
            exit(EX_USAGE)
        }
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
