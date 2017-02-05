//
//  TargetTests.swift
//  xclean
//
//  Created by Deszip on 04/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble

class FileManagerMock: FileManager {
    
    var stubbedURLs: [URL: UInt64] = [:]
    
    override func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions = []) throws -> [URL] {
        return Array(stubbedURLs.keys)
    }
    
    override func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        isDirectory?.initialize(to: ObjCBool(true), count: 1)
        return true
    }
    
    override func attributesOfItem(atPath path: String) throws -> [FileAttributeKey : Any] {
        return [FileAttributeKey.size : stubbedURLs[URL(fileURLWithPath: path)] as Any]
    }
    
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

class TargetTests: XCTestCase {

    var fileManagerMock: FileManagerMock?
    var filterMock: FilterMock = FilterMock()
    var target: Target?
    
    override func setUp() {
        super.setUp()
        
        let signature = TargetSignature(type: TargetType.derivedData)
        fileManagerMock = FileManagerMock()
        let fileManager = XCFileManager(fileManager: fileManagerMock!)
        target = Target(signature: signature, fileManager: fileManager, environment: Environment())
    }
    
    override func tearDown() {
        target = nil
        
        super.tearDown()
    }

    func testTargetStoresEntriesForURLs() {
        fileManagerMock?.stubbedURLs = [URL(fileURLWithPath: "/tmp/foo") : 0]
        
        target?.updateMetadata()
        
        expect(self.target?.entries.count).to(equal(1))
    }

    func testTargetAppliesFilter() {
        filterMock.shouldFail = true
        fileManagerMock?.stubbedURLs = [URL(fileURLWithPath: "/tmp/foo") : 0]
        target?.filter = filterMock
        
        target?.updateMetadata()
        
        expect(self.target?.entries.count).to(equal(0))
    }
    
    /*
    func testTargetSortsEntriesBySize() {
        fileManagerMock?.stubbedURLs = [URL(fileURLWithPath: "/tmp/foo") : 10, URL(fileURLWithPath: "/tmp/bar") : 20]
        
        target?.updateMetadata()
        
        expect(self.target?.entries[0].size).to(equal(20))
        expect(self.target?.entries[1].size).to(equal(10))
    }
    */
    
}
