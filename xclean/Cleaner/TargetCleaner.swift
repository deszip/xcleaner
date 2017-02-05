//
//  TargetCleaner.swift
//  xclean
//
//  Created by Deszip on 22/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

protocol TargetCleaner {
    func processEntries(_ entries: [Entry]) -> [Entry]
    func clean() -> [Entry]
    func entriesDescription() -> String
    func entriesSize() -> Int64
}
