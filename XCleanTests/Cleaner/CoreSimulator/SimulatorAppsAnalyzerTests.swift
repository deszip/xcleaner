//
//  SimulatorAppsAnalyzerTests.swift
//  xclean
//
//  Created by Deszip on 18/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble

class SimulatorAppsAnalyzerTests: XCTestCase {

    let fileManagerMock = FileManagerMock(fileManager: FileManager.default)
    var analyzer: SimulatorAppsAnalyzer?
    
    override func setUp() {
        super.setUp()
        
        analyzer = SimulatorAppsAnalyzer(fileManager: fileManagerMock)
    }
    
    override func tearDown() {
        analyzer = nil
        
        super.tearDown()
    }

    func testAnalyazerReturnsEmptyIfAppsURLDoesNotExist() {
        fileManagerMock.stubbedURLs = [:]
        
        let fakeEntry = Entry(url: URL(fileURLWithPath: ""))
        let apps: [Entry]? = analyzer?.outdatedApps(simulatorEntries: [fakeEntry])
        
        expect(apps!.count).to(equal(0))
    }
    
    func testAnalyazerIgnoresDefaultFilterValues() {
        let simURL = URL(fileURLWithPath: "foo")
        let appsURL = simURL.appendingPathComponent("/data/Containers/Bundle/Application/")
        let fakeSimEntry = Entry(url: simURL)
        let fakeAppEntry = Entry(url: appsURL.appendingPathComponent("Bar.app"))
        fileManagerMock.stubbedURLs = [appsURL : 42]
        fileManagerMock.stubbedEntries = [fakeAppEntry.url : 42]
        
        analyzer?.appCleanTimeout = 0
        analyzer?.appName = nil
        let apps: [Entry]? = analyzer?.outdatedApps(simulatorEntries: [fakeSimEntry])
        
        expect(apps!.count).to(equal(2))
    }
    
}
