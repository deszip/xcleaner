//
//  TargetFilter.swift
//  xclean
//
//  Created by Deszip on 08/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

protocol TargetFilter {
    func filter(_ entries: [Entry]) -> [Entry]
}
