//
//  TargetCleanerMock.swift
//  xclean
//
//  Created by Deszip on 26/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class TargetCleanerMock : TargetCleaner {
    required init(fileManager: XCFileManager, urls: [URL], environment: EnvironmentInteractor) {}
    
    var cleanCalled: Bool = false
    func clean() {
        cleanCalled = true
    }
    
    var entriesDescriptionCalled: Bool = false
    var entriesDescriptionValue = ""
    func entriesDescription() -> String {
        entriesDescriptionCalled = true
        return entriesDescriptionValue
    }
    
    var entriesSizeCalled: Bool = false
    var entriesSizeValue: Int64 = 0
    func entriesSize() -> Int64 {
        entriesSizeCalled = true
        return entriesSizeValue
    }
    
    var filter: TargetFilter?
    
    var entriesValue: [Entry] = []
    var entries: [Entry] { get { return entriesValue } }
}
