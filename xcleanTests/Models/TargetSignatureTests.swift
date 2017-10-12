//
//  TargetSignatureTests.swift
//  xclean
//
//  Created by Deszip on 04/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble
@testable import xcleaner

class TargetSignatureTests: XCTestCase {

    func testTargetSignatureURLs() {
        let derivedDataSignature = TargetSignature(type: TargetType.derivedData)
        let archivesSignature = TargetSignature(type: TargetType.archives)
        let deviceSupportSignature = TargetSignature(type: TargetType.deviceSupport)
        let coreSimulatorSignature = TargetSignature(type: TargetType.coreSimulator)
        
        expect(derivedDataSignature.urls[0].path.hasSuffix("Library/Developer/Xcode/DerivedData")).to(beTrue())
        expect(archivesSignature.urls[0].path.hasSuffix("Library/Developer/Xcode/Archives")).to(beTrue())
        expect(deviceSupportSignature.urls[0].path.hasSuffix("Library/Developer/Xcode/iOS DeviceSupport")).to(beTrue())
        expect(deviceSupportSignature.urls[1].path.hasSuffix("Library/Developer/Xcode/watchOS DeviceSupport")).to(beTrue())
        expect(coreSimulatorSignature.urls[0].path.hasSuffix("Library/Developer/CoreSimulator/Devices")).to(beTrue())
        expect(coreSimulatorSignature.urls[1].path.hasSuffix("Library/Developer/CoreSimulator")).to(beTrue())
    }
    
    func testTargetSignatureAllGetsAllTargets() {
        let allTargets = TargetSignature.all()
        
        expect(allTargets.count).to(equal(6))
    }

}
