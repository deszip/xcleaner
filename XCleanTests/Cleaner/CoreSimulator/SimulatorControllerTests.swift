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

    let simctlMock = SimctlInteractorMock()
    var controller: SimulatorController?
    
    override func setUp() {
        super.setUp()
        
        controller = SimulatorController(simctl: simctlMock)
    }
    
    override func tearDown() {
        controller = nil
        
        super.tearDown()
    }

    func testControllerHandlesEmptyOutput() {
        expect(self.controller?.unavailableSimulatorHashes().count).to(equal(0))
    }
    
    func testControllerHandlesMultipleUnavailable() {
        validateSimctlStub(SimctlStub.multipleUnavailable())
    }
    
    func testControllerHandlesOneUnavailable() {
        validateSimctlStub(SimctlStub.oneUnavailable())
    }

    func testControllerHandlesMixedUnavailable() {
        validateSimctlStub(SimctlStub.mixedUnavailable())
    }
    
    func testControllerHandlesNoUnavailable() {
        validateSimctlStub(SimctlStub.noUnavailable())
    }
    
    func testControllerHandlesInvalidSimctlOutput() {
        validateSimctlStub(SimctlStub.invalid())
    }
    
    private func validateSimctlStub(_ stub: SimctlStub) {
        simctlMock.loadStub(stub)
        expect(self.controller?.unavailableSimulatorHashes().count).to(equal(stub.unavailableCount))
    }
}
