//
//  TargetSignature.swift
//  xclean
//
//  Created by Deszip on 08/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

enum TargetType {
    case derivedData
    case archives
    case deviceSupport
    case coreSimulator
    case iphoneSimulator
    case xcodeCaches
    case backup
    case docSets
    
    func name() -> String {
        switch self {
            case .derivedData :     return "Derived Data"
            case .archives :        return "XCode archives"
            case .deviceSupport :   return "Device support"
            case .coreSimulator :   return "Core simulator"
            case .iphoneSimulator : return "iPhone simulator"
            case .xcodeCaches :     return "XCode caches"
            case .backup :          return "iTunes backups"
            case .docSets :         return "DocSets"
        }
    }
}

struct TargetSignature: Equatable {
    
    static let derivedDataPath          = "~/Library/Developer/Xcode/DerivedData"
    static let archivesPath             = "~/Library/Developer/Xcode/Archives"
    static let deviceSupportIOSPath     = "~/Library/Developer/Xcode/iOS DeviceSupport"
    static let deviceSupportWatchOSPath = "~/Library/Developer/Xcode/watchOS DeviceSupport"
    static let coreSimulatorUserPath    = "~/Library/Developer/CoreSimulator"
    static let coreSimulatorSystemPath  = "/Library/Developer/CoreSimulator"
    static let iphoneSimulatorPath      = "~/Library/Application Support/iPhone Simulator"
    static let xcodeCachesPath          = "~/Library/Caches/com.apple.dt.Xcode"
    static let backupPath               = "~/Library/Application Support/MobileSync/Backup"
    static let docSetsPath              = "~/Library/Developer/Shared/Documentation/DocSets"
    
    let type: TargetType
    let removable: Bool
    let urls: [URL]
    
    init(type: TargetType) {
        self.type = type
        
        switch type {
            case .derivedData:
                self.urls = [TargetSignature.urlForPath(TargetSignature.derivedDataPath)]
                self.removable = true
            
            case .archives:
                self.urls = [TargetSignature.urlForPath(TargetSignature.archivesPath)]
                self.removable = true
            
            case .deviceSupport:
                self.urls = [TargetSignature.urlForPath(TargetSignature.deviceSupportIOSPath),
                             TargetSignature.urlForPath(TargetSignature.deviceSupportWatchOSPath)]
                self.removable = true
            
            case .coreSimulator:
                self.urls = [TargetSignature.urlForPath(TargetSignature.coreSimulatorUserPath),
                             TargetSignature.urlForPath(TargetSignature.coreSimulatorSystemPath)]
                self.removable = false
            
            case .iphoneSimulator:
                self.urls = [TargetSignature.urlForPath(TargetSignature.iphoneSimulatorPath)]
                self.removable = false
            
            case .xcodeCaches:
                self.urls = [TargetSignature.urlForPath(TargetSignature.xcodeCachesPath)]
                self.removable = false
            
            case .backup:
                self.urls = [TargetSignature.urlForPath(TargetSignature.backupPath)]
                self.removable = false
            
            case .docSets:
                self.urls = [TargetSignature.urlForPath(TargetSignature.docSetsPath)]
                self.removable = false
        }
    }
    
    static func all() -> [TargetSignature] {
        return [TargetSignature(type: TargetType.derivedData),
                TargetSignature(type: TargetType.archives),
                TargetSignature(type: TargetType.deviceSupport),
                TargetSignature(type: TargetType.coreSimulator),
                TargetSignature(type: TargetType.iphoneSimulator),
                TargetSignature(type: TargetType.xcodeCaches),
                TargetSignature(type: TargetType.backup),
                TargetSignature(type: TargetType.docSets)]
    }
    
    private static func urlForPath(_ path: String) -> URL {
        let expandedPath = NSString(string: (path as NSString).expandingTildeInPath) as String
        return URL(fileURLWithPath: expandedPath, isDirectory: true)
    }
}

func ==(lhs: TargetSignature, rhs: TargetSignature) -> Bool {
    return lhs.type == rhs.type
}
