//
//  FormatterTests.swift
//  xclean
//
//  Created by Deszip on 21/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble

class FormatterTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFormatForEmptyInput() {
        let output = Formatter.alignedStringComponents([[]])
        expect(output).to(equal(""))
    }
    
    func testFormatForSingleLine() {
        let output = Formatter.alignedStringComponents([["element_1", "element_2", "element_3"]], minimumHorizontalSpacing: 5)
        expect(output).to(equal("element_1     element_2     element_3"))
    }
    
    func testFormatForSingleLineWithEmptyColumn() {
        let output = Formatter.alignedStringComponents([["element_1", "", "element_3"]], minimumHorizontalSpacing: 5)
        expect(output).to(equal("element_1          element_3"))
    }
    
    func testFormatForMultipleLinesWithEmptyColumn() {
        let output = Formatter.alignedStringComponents([["", "element_2", "element_3"], ["foo", "bar", "baz"]], minimumHorizontalSpacing: 5)
        expect(output).to(equal("        element_2     element_3\nfoo     bar           baz"))
    }
    
    func testFormatForMultipleLines() {
        let output = Formatter.alignedStringComponents([["element_1", "element_2", "element_3"], ["foo", "bar", "baz"]], minimumHorizontalSpacing: 5)
        expect(output).to(equal("element_1     element_2     element_3\nfoo           bar           baz"))
    }
    
    func testFormatForLineWithNewlines() {
        let output = Formatter.alignedStringComponents([["element_1", "element_2", "element_\n3"], ["foo", "bar", "baz"]], minimumHorizontalSpacing: 5)
        expect(output).to(equal("element_1     element_2     element_3\nfoo           bar           baz"))
    }

}
