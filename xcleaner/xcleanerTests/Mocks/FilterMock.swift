//
//  FilterMock.swift
//  xclean
//
//  Created by Deszip on 26/02/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation
@testable import xcleaner

class FilterMock : TargetFilter {
    
    var shouldFail: Bool = false
    
    func filter(_ entries: [Entry]) -> [Entry] {
        if shouldFail {
            return []
        }
        
        return entries
    }
}
