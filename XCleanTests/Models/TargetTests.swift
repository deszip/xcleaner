//
//  TargetTests.swift
//  xclean
//
//  Created by Deszip on 04/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble


class TargetTests: XCTestCase {

    var fileManagerMock: FileManagerMock?
    var filterMock: FilterMock = FilterMock()
    var cleanerMock: TargetCleanerMock?
    var environmentMock: EnvironmentMock = EnvironmentMock()
    
    var target: Target?
    
    override func setUp() {
        super.setUp()
        
        let signature = TargetSignature(type: TargetType.deviceSupport)
        fileManagerMock = FileManagerMock(fileManager: FileManager.default)
        cleanerMock = TargetCleanerMock(fileManager: self.fileManagerMock!, urls: [], environment: environmentMock)
        
        target = Target(signature: signature, environment: environmentMock, cleaner: cleanerMock)
    }
    
    override func tearDown() {
        target = nil
        
        super.tearDown()
    }

    func testTargetAsksCleanerForDescriptionIfEntriesSizeNotZero() {
        cleanerMock!.entriesSizeValue = 42
        
        let _ = target?.metadataDescription()
        
        expect(self.cleanerMock!.entriesDescriptionCalled).to(equal(true))
    }
    
    func testTargetDoesntAskCleanerForDescriptionIfEntriesSizeIsZero() {
        let _ = target?.metadataDescription()
        
        expect(self.cleanerMock!.entriesDescriptionCalled).to(equal(false))
    }
    
    func testTargetReturnsCleanerSize() {
        cleanerMock?.entriesSizeValue = 42
        
        expect(self.target!.safeSize()).to(equal(cleanerMock!.entriesSize()))
    }
    
    func testTargetCallsCleanOnCleaner() {
        target!.clean()
        
        expect(self.cleanerMock!.cleanCalled).to(equal(true))
    }
    
    func testTargetReturnCleanerEntries() {
        let entryURL = URL(fileURLWithPath: "/")
        let entry = Entry(url: entryURL)
        cleanerMock!.entriesValue = [entry]
        
        expect(self.target!.entries[0].url).to(equal(entry.url))
    }
    
    func testTargetAssignsFIlterToCleaner() {
        target!.filter = filterMock
        
        expect(self.cleanerMock!.filter).to(beIdenticalTo(self.filterMock))
    }
    
}
