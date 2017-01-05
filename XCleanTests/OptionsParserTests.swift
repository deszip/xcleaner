//
//  OptionsParserTests.swift
//  xclean
//
//  Created by Deszip on 04/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest

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
        
        XCTAssert(parser?.options.count == 1)
        XCTAssert(parser?.options[0] == Option.list(TargetSignature.all()))
    }

    func testOptionsParsesSingleOptionWithValue() {
        parser?.parse(arguments: ["/path/to/executable", "-l", "DerivedData"])
        
        XCTAssert(parser?.options.count == 1)
        XCTAssert(parser?.options[0] == Option.list([TargetSignature(type: TargetType.derivedData)]))
    }
    
    func testOptionsParsesMultipleOptionsWithValue() {
        parser?.parse(arguments: ["/path/to/executable", "-l", "DerivedData", "-r", "Archives"])
        
        XCTAssert(parser?.options.count == 2)
        XCTAssert(parser?.options[0] == Option.list([TargetSignature(type: TargetType.derivedData)]))
        XCTAssert(parser?.options[1] == Option.remove([TargetSignature(type: TargetType.archives)]))
    }
    
    func testOptionsParsesArgumentsWithoutExecutablePath() {
        parser?.parse(arguments: ["-l", "DerivedData"])
        
        XCTAssert(parser?.options.count == 1)
        XCTAssert(parser?.options[0] == Option.list([TargetSignature(type: TargetType.derivedData)]))
    }
    
    func testOptionsParsesEmptyInput() {
        parser?.parse(arguments: [])
        
        XCTAssert(parser?.options.count == 0)
    }
    
    func testOptionsParsesInvalidInput() {
        parser?.parse(arguments: ["foo", "-bar", "baz", "-a", "10"])
        
        XCTAssert(parser?.options.count == 2)
        XCTAssert(parser?.options[0] == Option.undefined)
        XCTAssert(parser?.options[1] == Option.undefined)
    }
}
