//
//  TargetTests.swift
//  xclean
//
//  Created by Deszip on 04/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble

// MARK: - Mocks -

class FileManagerMock: XCFileManager {
    
    var stubbedURLs: [URL: Int64] = [:]
    
    override func sizeOfDirectory(url: URL) -> Int64 { return 0 }
    
    override func fileExists(atURL url: URL) -> Bool { return true }
    
    override func removeEntry(_ entry: Entry) { }
    
    override func entriesAtURLs(_ urls: [URL], onlyDirectories: Bool) -> [Entry] {
        return stubbedURLs.map({ (url, size) -> Entry in
            let entry = Entry(url: url)
            entry.size = size
            entry.accessDate = Date()
            
            return entry
        })
    }
    
    override func fetchSize(entry: Entry) { }
}

class FilterMock : TargetFilter {
    
    var shouldFail: Bool = false
    
    func filter(_ entries: [Entry]) -> [Entry] {
        if shouldFail {
            return []
        }
        
        return entries
    }
}

class TargetCleanerMock : TargetCleaner {
    required init(fileManager: XCFileManager, urls: [URL], environment: Environment) {}
    
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

// MARK: - Tests -

class TargetTests: XCTestCase {

    var fileManagerMock: FileManagerMock?
    var filterMock: FilterMock = FilterMock()
    var cleanerMock: TargetCleanerMock?
    
    var target: Target?
    
    override func setUp() {
        super.setUp()
        
        let signature = TargetSignature(type: TargetType.deviceSupport)
        fileManagerMock = FileManagerMock(fileManager: FileManager.default)
        cleanerMock = TargetCleanerMock(fileManager: self.fileManagerMock!, urls: [], environment: Environment())
        
        target = Target(signature: signature, environment: Environment(), cleaner: cleanerMock)
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
