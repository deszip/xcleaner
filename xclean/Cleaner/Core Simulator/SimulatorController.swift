//
//  SimulatorController.swift
//  xclean
//
//  Created by Deszip on 05/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class SimulatorController {

    private let unavailableDelimiter    = "-- Unavailable:"
    private let sectionDelimiter        = "=="
    private let simulatorHashPattern    = "([a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12})"
    
    let simctlInteractor: SimctlInteractor
    
    init(simctl: SimctlInteractor? = nil) {
        simctlInteractor = simctl ?? SimctlInteractor()
    }
    
    func unavailableSimulatorHashes() -> [String] {
        let output = simctlInteractor.list().components(separatedBy: "\n")
        var unavailable = false
        let hashes: [String] = output.reduce([], { (unavailableHashes, line) in
            
            // Start
            if line.hasPrefix(unavailableDelimiter) {
                unavailable = true
                return unavailableHashes
            }
            
            // End
            if line.hasPrefix(sectionDelimiter) {
                unavailable = false
                return unavailableHashes
            }
            
            // Parse unavailable sim name
            if unavailable {
                do {
                    let regex = try NSRegularExpression(pattern: simulatorHashPattern)
                    let nsString = line as NSString
                    let results = regex.matches(in: line, range: NSRange(location: 0, length: nsString.length))
                    if let firstMatch = (results.map { nsString.substring(with: $0.range) }).first {
                        return unavailableHashes + [firstMatch]
                    }
                    return unavailableHashes
                } catch {
                    return unavailableHashes
                }
            } else {
                return unavailableHashes
            }
        })
        
        return hashes
    }
    
    func cleanUnavailable() {
        let _ = simctlInteractor.cleanUnavailable()
    }
    
}
