//
//  TargetSignature.swift
//  xclean
//
//  Created by Deszip on 08/01/2017.
//  Copyright © 2017 Deszip. All rights reserved.
//

import Foundation

public enum TargetType {
    case derivedData
    case archives
    case deviceSupport
    case coreSimulator
    case iphoneSimulator
    case xcodeCaches
    
    func name() -> String {
        switch self {
            case .derivedData :     return "Derived Data"
            case .archives :        return "XCode archives"
            case .deviceSupport :   return "Device support"
            case .coreSimulator :   return "Core simulator"
            case .iphoneSimulator : return "iPhone simulator"
            case .xcodeCaches :     return "XCode caches"
        }
    }
}

public struct TargetSignature: Equatable {
    
    static let derivedDataPath          = "~/Library/Developer/Xcode/DerivedData"
    static let archivesPath             = "~/Library/Developer/Xcode/Archives"
    static let deviceSupportIOSPath     = "~/Library/Developer/Xcode/iOS DeviceSupport"
    static let deviceSupportWatchOSPath = "~/Library/Developer/Xcode/watchOS DeviceSupport"
    static let coreSimulatorUserPath    = "~/Library/Developer/CoreSimulator/Devices"
    static let coreSimulatorSystemPath  = "/Library/Developer/CoreSimulator"
    static let iphoneSimulatorPath      = "~/Library/Application Support/iPhone Simulator"
    static let xcodeCachesPath          = "~/Library/Caches/com.apple.dt.Xcode"
    
    let type: TargetType
    let enabled: Bool
    let removable: Bool
    let urls: [URL]
    
    public init(type: TargetType) {
        self.type = type
        
        switch type {
            case .derivedData:
                self.urls = [TargetSignature.urlForPath(TargetSignature.derivedDataPath)]
                self.removable = true
                self.enabled = true
            
            case .archives:
                self.urls = [TargetSignature.urlForPath(TargetSignature.archivesPath)]
                self.removable = true
                self.enabled = true
            
            case .deviceSupport:
                self.urls = [TargetSignature.urlForPath(TargetSignature.deviceSupportIOSPath),
                             TargetSignature.urlForPath(TargetSignature.deviceSupportWatchOSPath)]
                self.removable = true
                self.enabled = true
            
            case .coreSimulator:
                self.urls = [TargetSignature.urlForPath(TargetSignature.coreSimulatorUserPath),
                             TargetSignature.urlForPath(TargetSignature.coreSimulatorSystemPath)]
                self.removable = true
                self.enabled = true
            
            
            // Disabled for now...
            
            case .iphoneSimulator:
                self.urls = [TargetSignature.urlForPath(TargetSignature.iphoneSimulatorPath)]
                self.removable = false
                self.enabled = false
            
            case .xcodeCaches:
                self.urls = [TargetSignature.urlForPath(TargetSignature.xcodeCachesPath)]
                self.removable = false
                self.enabled = false
        }
    }
    
    public static func all() -> [TargetSignature] {
        return [TargetSignature(type: TargetType.derivedData),
                TargetSignature(type: TargetType.archives),
                TargetSignature(type: TargetType.deviceSupport),
                TargetSignature(type: TargetType.coreSimulator),
                TargetSignature(type: TargetType.iphoneSimulator),
                TargetSignature(type: TargetType.xcodeCaches)]
    }
    
    public static func signaturesForOption(_ option: MultiStringOption) -> [TargetSignature]? {
        let targetNames = option.value ?? []
        var signatures = targetNames.flatMap { TargetSignature.signatureForTarget(target: $0) }
        
        // Having more arguments than signatures means some arguments are invalid
        if targetNames.count != signatures.count {
            return nil;
        }
        
        // If no arguments provided - assume all targets
        if signatures.count == 0 {
            signatures = TargetSignature.all()
        }
        
        return signatures
    }
    
    private static func signatureForTarget(target: String?) -> TargetSignature? {
        guard let target = target else {
            return nil
        }
        
        switch target {
            case "DerivedData" : return TargetSignature(type: TargetType.derivedData)
            case "Archives" : return TargetSignature(type: TargetType.archives)
            case "DeviceSupport" : return TargetSignature(type: TargetType.deviceSupport)
            case "CoreSimulator" : return TargetSignature(type: TargetType.coreSimulator)
            case "iPhoneSimulator" : return TargetSignature(type: TargetType.iphoneSimulator)
            case "XCodeCaches" : return TargetSignature(type: TargetType.xcodeCaches)
            
            default: return nil
        }
    }
    
    private static func urlForPath(_ path: String) -> URL {
        let expandedPath = NSString(string: (path as NSString).expandingTildeInPath) as String
        return URL(fileURLWithPath: expandedPath, isDirectory: true)
    }
}

public func ==(lhs: TargetSignature, rhs: TargetSignature) -> Bool {
    return lhs.type == rhs.type
}

