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

// MARK: - Tests -

class TargetTests: XCTestCase {

    var fileManagerMock: FileManagerMock?
    var filterMock: FilterMock = FilterMock()
    var target: Target?
    
    override func setUp() {
        super.setUp()
        
        let signature = TargetSignature(type: TargetType.deviceSupport)
        fileManagerMock = FileManagerMock(fileManager: FileManager.default)
        target = Target(signature: signature, fileManager: fileManagerMock!, environment: Environment())
    }
    
    override func tearDown() {
        target = nil
        
        super.tearDown()
    }

    func testTargetStoresEntriesForURLs() {
        fileManagerMock?.stubbedURLs = [URL(fileURLWithPath: "/tmp/foo") : 0]
        
        expect(self.target?.entries.count).to(equal(1))
    }

    func testTargetAppliesFilter() {
        filterMock.shouldFail = true
        fileManagerMock?.stubbedURLs = [URL(fileURLWithPath: "/tmp/foo") : 0]
        target?.filter = filterMock
        
        expect(self.target?.entries.count).to(equal(0))
    }
    
    func testTargetSortsEntriesBySize() {
        fileManagerMock?.stubbedURLs = [URL(fileURLWithPath: "/tmp/foo") : 10, URL(fileURLWithPath: "/tmp/bar") : 20]
        filterMock.shouldFail = false
        
        let signature = TargetSignature(type: TargetType.deviceSupport)
        target = Target(signature: signature, fileManager: fileManagerMock!, environment: Environment())
        
        expect(self.target?.entries[0].size).to(equal(20))
        expect(self.target?.entries[1].size).to(equal(10))
    }
    
    /*
    func testTargetUpdatesEntrySize() {
        
    }
    */
    
}
