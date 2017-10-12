//
//  EnvironmentTests.swift
//  xclean
//
//  Created by Deszip on 19/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble
@testable import xcleaner

class EnvironmentTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEnvironmentListOption() {
        var environment = Environment(arguments: ["path/to/exec", "-l"])
        expect(environment.listOption.wasSet).to(beTrue())
        
        environment = Environment(arguments: ["path/to/exec", "--list"])
        expect(environment.listOption.wasSet).to(beTrue())
        
        environment = Environment(arguments: ["path/to/exec", "-l", "bar"])
        expect(environment.listOption.wasSet).to(beTrue())
        expect(environment.listOption.value![0]).to(equal("bar"))

        environment = Environment(arguments: ["path/to/exec", "-l", "bar", "baz"])
        expect(environment.listOption.wasSet).to(beTrue())
        expect(environment.listOption.value![0]).to(equal("bar"))
        expect(environment.listOption.value![1]).to(equal("baz"))
    }
    
    func testEnvironmentRemoveOption() {
        var environment = Environment(arguments: ["path/to/exec", "-r"])
        expect(environment.removeOption.wasSet).to(beTrue())
        
        environment = Environment(arguments: ["path/to/exec", "--remove"])
        expect(environment.removeOption.wasSet).to(beTrue())
        
        environment = Environment(arguments: ["path/to/exec", "-r", "bar"])
        expect(environment.removeOption.wasSet).to(beTrue())
        expect(environment.removeOption.value![0]).to(equal("bar"))
        
        environment = Environment(arguments: ["path/to/exec", "-r", "bar", "baz"])
        expect(environment.removeOption.wasSet).to(beTrue())
        expect(environment.removeOption.value![0]).to(equal("bar"))
        expect(environment.removeOption.value![1]).to(equal("baz"))
    }
    
    func testEnvironmentTimeoutOption() {
        var environment = Environment(arguments: ["path/to/exec", "-t", "10"])
        expect(environment.timeoutOption.wasSet).to(beTrue())
        
        environment = Environment(arguments: ["path/to/exec", "--timeout", "10"])
        expect(environment.timeoutOption.value).to(equal(10))
    }
    
    func testEnvironmentAppNameOption() {
        var environment = Environment(arguments: ["path/to/exec", "-a", "Foo"])
        expect(environment.appOption.wasSet).to(beTrue())
        
        environment = Environment(arguments: ["path/to/exec", "--app", "Foo"])
        expect(environment.appOption.value).to(equal("Foo"))
    }
    
    func testEnvironmentHelpOption() {
        var environment = Environment(arguments: ["path/to/exec", "-h"])
        expect(environment.helpOption.wasSet).to(beTrue())
        
        environment = Environment(arguments: ["path/to/exec", "--help"])
        expect(environment.helpOption.wasSet).to(beTrue())
    }
    
    func testEnvironmentVersionOption() {
        var environment = Environment(arguments: ["path/to/exec", "-v"])
        expect(environment.versionOption.wasSet).to(beTrue())
        
        environment = Environment(arguments: ["path/to/exec", "--version"])
        expect(environment.versionOption.wasSet).to(beTrue())
    }

}
