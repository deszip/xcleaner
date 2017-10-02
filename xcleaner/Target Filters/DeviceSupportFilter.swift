//
//  DeviceSupportFilter.swift
//  xclean
//
//  Created by Deszip on 08/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class DeviceSupportFilter: TargetFilter {
    
    func filter(_ entries: [Entry]) -> [Entry] {
        let currentDate = Date()
        return entries.filter { osDirectory -> Bool in
            currentDate.timeIntervalSince(osDirectory.accessDate) > 3600 * 24 * 30
        }
    }
    
}
