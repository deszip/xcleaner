//
//  SimulatorControllerTests.swift
//  xclean
//
//  Created by Deszip on 19/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble

class SimulatorControllerTests: XCTestCase {

    var controller: SimulatorController?
    
    override func setUp() {
        super.setUp()
        
        controller = SimulatorController(simctl: SimctlInteractorMock())
    }
    
    override func tearDown() {
        controller = nil
        
        super.tearDown()
    }

    func testControllerHandlesEmptyOutput() {
        expect(self.controller?.unavailableSimulatorHashes().count).to(equal(0))
    }

}
