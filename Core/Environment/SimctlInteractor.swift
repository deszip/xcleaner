//
//  SimctlInteractor.swift
//  xclean
//
//  Created by Deszip on 19/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class SimctlInteractor: ProcessInteractor {
    
    func list() -> String {
        return launch(launchPath: "/usr/bin/xcrun", arguments: ["simctl", "list"])
    }
    
    func cleanUnavailable() -> String {
        return launch(launchPath: "/usr/bin/xcrun", arguments: ["simctl", "delete", "unavailable"])
    }
    
}
