//
//  Formatter.swift
//  xclean
//
//  Created by Deszip on 07/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Formatter {

    class func formattedSize(size: Int64) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = .useAll
        byteCountFormatter.countStyle = .file
        let formattedSize = byteCountFormatter.string(fromByteCount: size)
        
        return formattedSize
    }
    
    class func alignedStringComponents(_ components: [String], padding: Int) -> String {
        return components.map { item -> String in
            item.padding(toLength: padding, withPad: " ", startingAt: 0)
        }.joined(separator: "") + "\n"
    }
    
    class func alignedStringComponents(_ components: [[String]]) -> String {
        let paddings = components.reduce([], { (paddings, line) in
            return line.map({ component -> Int in
                let length = component.lengthOfBytes(using: String.Encoding.utf8)
                if let index = line.index(of: component) {
                    if paddings.count <= index {
                        return length
                    }
                    
                    if paddings[index] < length {
                        return length
                    }
                    
                    return paddings[index]
                }
                return length
            })
        })
        
        print(paddings)
        
        let lines = components.map { (line) -> String in
            var lineString = ""
            line.enumerated().forEach({ (index, component) in
                lineString += component.padding(toLength: paddings[index] + 5, withPad: " ", startingAt: 0)
            })
            
            return lineString
        }
        
        return lines.joined(separator: "\n") + "\n\n"
    }
}
