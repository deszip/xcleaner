//
//  EnvironmentMock.swift
//  xclean
//
//  Created by Deszip on 12/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class EnvironmentMock: EnvironmentInteractor {
    var fileManager: XCFileManager
    
    func stdout(_ string: String) {}
    func stderr(_ string: String) {}
    func terminate(success: Bool) {}
    
    var listOption: MultiStringOption
    var removeOption: MultiStringOption
    var timeoutOption: IntOption
    var appOption: StringOption
    var helpOption: BoolOption
    var versionOption: BoolOption
    
    init() {
        self.fileManager = FileManagerMock(fileManager: FileManager.default)
        
        listOption = MultiStringOption(shortFlag: "l",
                                       longFlag: "list",
                                       helpMessage: "Lists target stats.")
        
        removeOption = MultiStringOption(shortFlag: "r",
                                         longFlag: "remove",
                                         helpMessage: "Cleans targets.")
        
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
    }
    
}
