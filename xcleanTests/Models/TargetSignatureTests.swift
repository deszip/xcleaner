//
//  TargetSignatureTests.swift
//  xclean
//
//  Created by Deszip on 04/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble

class TargetSignatureTests: XCTestCase {

    // MARK: - Signature options -
    
    func testTargetSignatureURLs() {
        let derivedDataSignature    = TargetSignature(type: TargetType.derivedData)
        let archivesSignature       = TargetSignature(type: TargetType.archives)
        let deviceSupportSignature  = TargetSignature(type: TargetType.deviceSupport)
        let coreSimulatorSignature  = TargetSignature(type: TargetType.coreSimulator)
        
        expect(derivedDataSignature.urls[0].path.hasSuffix("Library/Developer/Xcode/DerivedData")).to(beTrue())
        expect(archivesSignature.urls[0].path.hasSuffix("Library/Developer/Xcode/Archives")).to(beTrue())
        expect(deviceSupportSignature.urls[0].path.hasSuffix("Library/Developer/Xcode/iOS DeviceSupport")).to(beTrue())
        expect(deviceSupportSignature.urls[1].path.hasSuffix("Library/Developer/Xcode/watchOS DeviceSupport")).to(beTrue())
        expect(coreSimulatorSignature.urls[0].path.hasSuffix("Library/Developer/CoreSimulator/Devices")).to(beTrue())
        expect(coreSimulatorSignature.urls[1].path.hasSuffix("Library/Developer/CoreSimulator")).to(beTrue())
    }
    
    func testTargetTypes() {
        let derivedDataSignature        = buildSignature("DerivedData")
        let archivesSignature           = buildSignature("Archives")
        let deviceSupportSignature      = buildSignature("DeviceSupport")
        let coreSimulatorSignature      = buildSignature("CoreSimulator")
        let iphoneSimulatorSignature    = buildSignature("iPhoneSimulator")
        let xcodeCachesSignature        = buildSignature("XCodeCaches")
        
        // Verify types
        expect(derivedDataSignature?.type).to(equal(TargetType.derivedData))
        expect(archivesSignature?.type).to(equal(TargetType.archives))
        expect(deviceSupportSignature?.type).to(equal(TargetType.deviceSupport))
        expect(coreSimulatorSignature?.type).to(equal(TargetType.coreSimulator))
        expect(iphoneSimulatorSignature?.type).to(equal(TargetType.iphoneSimulator))
        expect(xcodeCachesSignature?.type).to(equal(TargetType.xcodeCaches))
        
        // Verify removability
        expect(derivedDataSignature?.removable).to(beTrue())
        expect(archivesSignature?.removable).to(beTrue())
        expect(deviceSupportSignature?.removable).to(beTrue())
        expect(coreSimulatorSignature?.removable).to(beTrue())
        expect(iphoneSimulatorSignature?.removable).to(beFalse())
        expect(xcodeCachesSignature?.removable).to(beFalse())
        
        // Verify availability
        expect(derivedDataSignature?.enabled).to(beTrue())
        expect(archivesSignature?.enabled).to(beTrue())
        expect(deviceSupportSignature?.enabled).to(beTrue())
        expect(coreSimulatorSignature?.enabled).to(beTrue())
        expect(iphoneSimulatorSignature?.enabled).to(beFalse())
        expect(xcodeCachesSignature?.enabled).to(beFalse())
    }
    
    // MARK: - Signature building -
    
    func testTargetSignatureAllGetsAllTargets() {
        let option = buildOptionStub()
        let allTargets = TargetSignature.signaturesForOption(option)
        
        expect(allTargets?.count).to(equal(6))
    }
    
    func testTargetSignatureBuildSignature() {
        let option = buildOptionStub(["DerivedData"])
        
        let signatures = TargetSignature.signaturesForOption(option)
        
        expect(signatures?.count).to(equal(1))
    }
    
    func testTargetSignatureReturnsNilForInvalidArgument() {
        let option = buildOptionStub(["foo"])
        
        let signatures = TargetSignature.signaturesForOption(option)
        
        expect(signatures).to(beNil())
    }
    
    func testTargetSignatureReturnsNilForAtLeastOneInvalidArgument() {
        let option = buildOptionStub(["DerivedData", "foo"])
        
        let signatures = TargetSignature.signaturesForOption(option)
        
        expect(signatures).to(beNil())
    }
    
    // MARK: - Equality -
    
    func testTargetEquality() {
        let derivedDataTarget1 = TargetSignature(type: TargetType.derivedData)
        let derivedDataTarget2 = TargetSignature(type: TargetType.derivedData)
        let archivesTarget = TargetSignature(type: TargetType.archives)
        
        expect(derivedDataTarget1).toNot(equal(archivesTarget))
        expect(derivedDataTarget1).to(equal(derivedDataTarget2))
    }
    
    // MARK: - Builders -
    
    private func buildOptionStub(_ values: [String]? = nil) -> MultiStringOption {
        let option = MultiStringOption("f", "foo", true, "")
        if let values = values {
            let _ = option.setValue(values)
        }
        
        return option
    }
    
    private func buildSignature(_ target: String?) -> TargetSignature? {
        var optionValues: [String]? = nil
        if let target = target {
            optionValues = [target]
        }
        let option = buildOptionStub(optionValues)

        return TargetSignature.signaturesForOption(option)?[0]
    }

}
