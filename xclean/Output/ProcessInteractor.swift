//
//  ProcessInteractor.swift
//  xclean
//
//  Created by Deszip on 19/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class ProcessInteractor {
    
    private var processes: [(Process, Pipe)] = []
    
    func launch(launchPath: String, arguments: [String]? = nil) -> String {
        let process = Process()
        let pipe = Pipe()
        process.launchPath = launchPath
        process.standardOutput = pipe
        process.arguments = arguments
        processes.append((process, pipe))
        process.launch()
        
        let outputHandle = pipe.fileHandleForReading
        return String(data: outputHandle.readDataToEndOfFile(), encoding: String.Encoding.utf8) ?? ""
    }
}
