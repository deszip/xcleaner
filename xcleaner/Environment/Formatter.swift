//
//  Formatter.swift
//  xclean
//
//  Created by Deszip on 07/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

class Formatter {

    private let dateFormatter = DateFormatter()
    
    init() {
        self.dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    }
    
    class func formattedSize(_ size: Int64) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = .useAll
        byteCountFormatter.countStyle = .file
        let formattedSize = byteCountFormatter.string(fromByteCount: size)
        
        return formattedSize
    }
    
    func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    class func alignedStringComponents(_ components: [[String]], minimumHorizontalSpacing: Int = 5) -> String {
        // Get paddings
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
        
        // Format lines
        let lines = components.map { (line) -> String in
            var lineString = ""
            line.enumerated().forEach({ (arg) in
                let (index, component) = arg
                let trimmedCharacters = CharacterSet.controlCharacters.union(CharacterSet.illegalCharacters).union(CharacterSet.newlines)
                let cleanComponent = component.components(separatedBy: trimmedCharacters).joined()
                if index == line.count - 1 {
                    lineString += cleanComponent
                } else {
                    lineString += cleanComponent.padding(toLength: paddings[index] + minimumHorizontalSpacing, withPad: " ", startingAt: 0)
                }
            })
            
            return lineString
        }
        
        return lines.joined(separator: "\n")
    }

}
