//
//  Environment.swift
//  xclean
//
//  Created by Deszip on 07/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

protocol EnvironmentInteractor {
    var fileManager: XCFileManager { get }
    
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
    
    // MARK: - File manager -
    let fileManager: XCFileManager
    
    // MARK: - I/O -
    private let stdoutHandle: FileHandle
    private let stderrHandle: FileHandle
    
    // MARK: - Arguments -
    let cli: CommandLine
    let listOption: MultiStringOption
    let removeOption: MultiStringOption
    let timeoutOption: IntOption
    let appOption: StringOption
    let helpOption: BoolOption
    let versionOption: BoolOption
    
    init(arguments: [String] = Swift.CommandLine.arguments, fileManager: XCFileManager = XCFileManager(fileManager: FileManager.default)) {
        self.fileManager = fileManager
        
        self.stdoutHandle = FileHandle.standardOutput
        self.stderrHandle = FileHandle.standardError
        
        cli = CommandLine(arguments: arguments)
        
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
        
        cli.addOptions(listOption, removeOption, timeoutOption, appOption, helpOption, versionOption)
        
        do {
            try cli.parse()
        } catch {
            stdout("\(error)\n\n")
            printUsage()
            exit(EX_USAGE)
        }
    }
    
    func printUsage() {
        stdout(
            "Cleans some of the stuff created by XCode.\n" +
            "May corrupt or remove any random data on your or your neighbours discs, you were warned :)\n\n" +
                
            "Usage:\n" +
            "   xclean [-l] <TARGET> [-r] <TARGET> [-t] <TIMEOUT> [-a] <APPNAME>\n\n" +
            
            "Arguments:\n" +
            "   <TARGET>                  Traget to clean. Available targets: DerivedData, Archives, DeviceSupport, CoreSimulator\n" +
            "   <TIMEOUT>                 Timeout value in seconds.\n" +
            "   <APPNAME>                 Name of the app as it appears in simulator, CFBundleDisplayName key from Info.plist.\n\n" +
                
            "Options:\n" +
            "   -l --list <TARGET>        Lists files that could be relatively safely removed.\n" +
            "                             Pass target name to list only it.\n" +
            "                             If no value passed - uses all targets.\n" +
            "   -r --remove <TARGET>      Removes files listed by -l\n" +
            "   -t --timeout <TIMEOUT>    Sets interval for assuming file is old.\n" +
            "                             -r and -l will process only files with last access date older than timeout\n" +
            "   -a -app <APPNAME>         Sets application name for filtering in simulators. Used only for CoreSimulator target.\n" +
            "                             e.g. xclean -l CoreSimulator -a SomeApp will list all instances of 'SomeApp' in simulators.\n" +
            "   -v --version              Print the version of the application\n"
        )
    }
    
    func printVersion() {
        stdout("0.0.1\n")
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
