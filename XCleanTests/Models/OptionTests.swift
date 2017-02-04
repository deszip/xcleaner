//
//  OptionTests.swift
//  xclean
//
//  Created by Deszip on 04/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import XCTest
import Nimble

class OptionTests: XCTestCase {

    // MARK: - General -
    
    func testOptionHandlesUndefinedInput() {
        let option = Option(option: "Bar", value: nil)
        
        expect(option).to(equal(Option.undefined))
    }
    
    func testOptionWithoutArgumentsDefaultsToAll() {
        let option = Option(option: "l", value: nil)
        
        switch option {
            case .list(let targets): expect(targets.count).to(equal(6))
            default: XCTFail()
        }
    }
    
    func testOptionParsesTargetType() {
        let derivedDataOption = Option(option: "l", value: "DerivedData")
        let archivesOption = Option(option: "l", value: "Archives")
        let deviceSupportOption = Option(option: "l", value: "DeviceSupport")
        let coreSimulatorOption = Option(option: "l", value: "CoreSimulator")
        let iPhoneSimulatorOption = Option(option: "l", value: "iPhoneSimulator")
        let xcodeCachesOption = Option(option: "l", value: "XCodeCaches")
        
        validateOption(option: derivedDataOption, targetType: TargetType.derivedData)
        validateOption(option: archivesOption, targetType: TargetType.archives)
        validateOption(option: deviceSupportOption, targetType: TargetType.deviceSupport)
        validateOption(option: coreSimulatorOption, targetType: TargetType.coreSimulator)
        validateOption(option: iPhoneSimulatorOption, targetType: TargetType.iphoneSimulator)
        validateOption(option: xcodeCachesOption, targetType: TargetType.xcodeCaches)
    }
    
    func testOptionHelp() {
        let option = Option(option: "h")
        expect(option).to(equal(Option.help))
    }
    
    func testOptionVersion() {
        let option = Option(option: "v")
        expect(option).to(equal(Option.version))
    }
    
    // MARK: - List -
    
    func testOptionHandlesArgumentForList() {
        let option = Option(option: "l", value: "DerivedData")
        
        validateOption(option: option, targetType: TargetType.derivedData)
    }

    func testOptionIgnoresInvalidArgumentForList() {
        let option = Option(option: "l", value: "Bar")
        
        switch option {
            case .list(let targets): expect(targets.count).to(equal(6))
            default: XCTFail()
        }
    }
    
    // MARK: - Remove -
    
    func testOptionHandlesArgumentForRemove() {
        let option = Option(option: "r", value: "DerivedData")
        
        validateOption(option: option, targetType: TargetType.derivedData)
    }
    
    func testOptionIgnoresInvalidArgumentForRemove() {
        let option = Option(option: "r", value: "Bar")
        
        switch option {
            case .remove(let targets): expect(targets.count).to(equal(6))
            default: XCTFail()
        }
    }
    
    // MARK: - Timeout -
    
    func testOptionHandlesTimeout() {
        let option = Option(option: "t", value: "10")
        
        switch option {
            case .timeout(let timeout): expect(timeout).to(equal(10))
            default: XCTFail()
        }
    }
    
    func testOptionHandlesInvalidTimeout() {
        let option = Option(option: "t", value: "Bar")
        
        switch option {
            case .timeout(let timeout): expect(timeout).to(equal(0))
            default: XCTFail()
        }
    }
    
    // MARK: - Tools -
    
    func validateOption(option: Option, targetType: TargetType) {
        let validator: ([TargetSignature]) -> Void = { targets in
            expect(targets.count).to(equal(1))
            expect(targets[0].type).to(equal(targetType))
        }
        
        switch option {
            case .list(let targets): validator(targets)
            case .remove(let targets): validator(targets)
            default: XCTFail()
        }
    }
    
}
