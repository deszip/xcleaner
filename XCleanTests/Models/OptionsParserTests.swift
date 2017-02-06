//
//  OptionsParserTests.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble

class OptionsParserTests: XCTestCase {

    var parser: OptionsParser?
    
    override func setUp() {
        super.setUp()
        
        parser = OptionsParser()
    }
    
    override func tearDown() {
        parser = nil
        
        super.tearDown()
    }

    func testOptionsParsesSingleOption() {
        parser?.parse(arguments: ["/path/to/executable", "-l"])
        
        expect(self.parser?.options.count).to(equal(1))
        expect(self.parser?.options[0]).to(equal(Option.list(TargetSignature.all())))
    }

    func testOptionsParsesSingleOptionWithValue() {
        parser?.parse(arguments: ["/path/to/executable", "-l", "DerivedData"])

        expect(self.parser?.options.count).to(equal(1))
        expect(self.parser?.options[0]).to(equal(Option.list([TargetSignature(type: TargetType.derivedData)])))
    }
    
    func testOptionsParsesMultipleOptionsWithValue() {
        parser?.parse(arguments: ["/path/to/executable", "-l", "DerivedData", "-r", "Archives"])
        
        expect(self.parser?.options.count).to(equal(2))
        expect(self.parser?.options[0]).to(equal(Option.list([TargetSignature(type: TargetType.derivedData)])))
        expect(self.parser?.options[1]).to(equal(Option.remove([TargetSignature(type: TargetType.archives)])))
    }
    
    func testOptionsParsesArgumentsWithoutExecutablePath() {
        parser?.parse(arguments: ["-l", "DerivedData"])
        
        expect(self.parser?.options.count).to(equal(1))
        expect(self.parser?.options[0]).to(equal(Option.list([TargetSignature(type: TargetType.derivedData)])))
    }
    
    func testOptionsParsesInvalidTarget() {
        parser?.parse(arguments: ["/path/to/executable", "-l", "foo"])
        
        expect(self.parser?.options.count).to(equal(1))
        expect(self.parser?.options[0]).to(equal(Option.list(TargetSignature.all())))
    }
    
    func testOptionsParsesEmptyInput() {
        parser?.parse(arguments: [])
        
        expect(self.parser?.options.count).to(equal(0))
    }
    
    func testOptionsParsesInvalidInput() {
        parser?.parse(arguments: ["foo", "-bar", "baz", "-x", "10"])
        
        expect(self.parser?.options.count).to(equal(2))
        expect(self.parser?.options[0]).to(equal(Option.undefined))
        expect(self.parser?.options[1]).to(equal(Option.undefined))
    }
}
