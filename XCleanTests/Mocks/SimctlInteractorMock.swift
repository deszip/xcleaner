//
//  SimctlInteractorMock.swift
//  xclean
//
//  Created by Deszip on 19/03/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class SimctlInteractorMock: SimctlInteractor {
    var output = ""
    override func list() -> String { return output }
    override func cleanUnavailable() -> String { return "" }
}
