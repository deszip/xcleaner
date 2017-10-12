//
//  SimctlInteractorMock.swift
//  xclean
//
//  Created by Deszip on 19/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

struct SimctlStub {
    let name: String
    let unavailableCount: Int
    
    static func multipleUnavailable() -> SimctlStub { return SimctlStub(name: "simctl_stub_multiple_unavailable", unavailableCount: 42) }
    static func oneUnavailable() -> SimctlStub { return SimctlStub(name: "simctl_stub_one_unavailable", unavailableCount: 1) }
    static func mixedUnavailable() -> SimctlStub { return SimctlStub(name: "simctl_stub_mixed_unavailable", unavailableCount: 42) }
    static func noUnavailable() -> SimctlStub { return SimctlStub(name: "simctl_stub_no_unavailable", unavailableCount: 0) }
    static func emptySection() -> SimctlStub { return SimctlStub(name: "simctl_stub_empty_unavailable_section", unavailableCount: 0) }
    static func invalid() -> SimctlStub { return SimctlStub(name: "simctl_stub_invalid", unavailableCount: 0) }
    
    func content() -> String {
        if let stubURL = Bundle(for: SimctlInteractorMock.self).url(forResource: name, withExtension: "txt") {
            return try! String(contentsOf: stubURL, encoding: .utf8)
        }
        
        return ""
    }
}

class SimctlInteractorMock: SimctlInteractor {
    var simctlStub: SimctlStub? = nil
    var output = ""
    var cleanCalled = false
    
    override func list() -> String { return output }
    override func cleanUnavailable() -> String { cleanCalled = true; return "" }
    
    func loadStub(_ stub: SimctlStub) {
        simctlStub = stub
        output = stub.content()
    }
}
