//
//  Helper.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import ApplicationServices
import AppKit

class Helper {
    
    static let REPO_PATH: String = "NNN-Studio/Abyssal"
    
    static let SOURCE_CODE_URL: URL 	= URL(string: "https://github.com/\(REPO_PATH)")!
    
    static let RELEASE_URL: URL 		= URL(string: "https://github.com/\(REPO_PATH)/releases")!
    
    static let RELEASE_TAGS_URL: URL 	= URL(string: "https://api.github.com/repos/\(REPO_PATH)/tags")!
    
    static let CHECK_NEWER_VERSION_TASK = URLSession.shared.dataTask(with: RELEASE_TAGS_URL) { (data, response, error) in
        guard let data = data else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                let tags = json.sorted { (v1, v2) -> Bool in
                    let name1 = v1["name"] as? String ?? ""
                    let name2 = v2["name"] as? String ?? ""
                    
                    return name2.compare(name1, options: .numeric) == .orderedAscending
                }
                
                if let latestTag = tags.first?["name"] as? String {
                    Helper.latestTag = latestTag
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static var version: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var _latestTag: String = ""
    
    static var latestTag: String {
        get {
            _latestTag
        }
        
        set(version) {
            let regex = /\d+\.\d+\.\d+/
            let nsVersion = version
            
            if let match = nsVersion.firstMatch(of: regex) {
                Helper._latestTag = String(match.output)
            }
        }
    }
    
    static var versionComponent: (needsUpdate: Bool, version: String) {
        if let version = version {
            switch compareVersions(version, latestTag) {
            case .orderedAscending:
                // Needs an update
                return (true, latestTag)
            default:
                return (false, version)
            }
        } else {
            debugPrint("Version check failed!")
            return (false, "")
        }
    }
    
    static var delegate: AppDelegate? {
        NSApplication.shared.delegate as? AppDelegate
    }
    
    static var menuBarLeftEdge: CGFloat {
        guard let width = Screen.maxWidth else { return 0 }
        
        if Screen.hasNotch {
            let notchWidth = 250.0
            return width / 2.0 + notchWidth / 2.0
        } else {
            return 50 // Apple icon + App name should be at least 50.
        }
    }
    
    static func approaching(
        _ a: CGFloat, _ b: CGFloat,
        _ ignoreSmallValues: Bool = true
    ) -> Bool {
        abs(a - b) < (ignoreSmallValues ? 1 : 0.001)
    }
    
    static func lerp(
        a:      CGFloat,
        b:      CGFloat,
        ratio:  CGFloat,
        _ ignoreSmallValues: Bool = true
    ) -> CGFloat {
        guard !ignoreSmallValues || !approaching(a, b, ignoreSmallValues) else { return b }
        return a + (b - a) * ratio
    }
    
    static func switchToTheme(
        _ index: Int
    ) {
        Data.theme = Themes.themes[index]
        
        Helper.delegate?.statusBarController.map()
        Helper.delegate?.statusBarController.startFunctionalTimers()
    }
    
    static func compareVersions(
        _ version1: String?,
        _ version2: String?
    ) -> ComparisonResult {
        if version1 == nil && version2 != nil { return .orderedAscending }
        else if version2 == nil && version1 != nil { return .orderedDescending }
        
        guard
            let version1 = version1,
            let version2 = version2
        else {
            return .orderedSame
        }
        
        if version1 == "" && version2 != "" { return .orderedAscending }
        else if version2 == "" && version1 != "" { return .orderedDescending }
        
        guard version1 != version2 else {
            return .orderedSame
        }
        
        let components1 = version1.components(separatedBy: ".")
        let components2 = version2.components(separatedBy: ".")
        let count = max(components1.count, components2.count)
        
        for i in 0..<count {
            let value1 = i < components1.count ? Int(components1[i]) ?? 0 : 0
            let value2 = i < components2.count ? Int(components2[i]) ?? 0 : 0
            if value1 < value2 {
                return .orderedAscending
            } else if value1 > value2 {
                return .orderedDescending
            }
        }
        
        return .orderedSame
    }
    
    class FormattedTime {
        
        static let SECONDS = String(localized: "Seconds")
        
        static let MINUTES = String(localized: "Minutes")
        
        static let FOREVER = String(localized: "Forever")
        
        static func orElseForever(_ number: Any?, unit: String) -> String {
            if let number = number as? LosslessStringConvertible {
                String(number) + Data.SPACE + unit
            } else {
                FOREVER
            }
        }
        
        static func inSeconds(_ number: Any?) -> String {
            orElseForever(number, unit: SECONDS)
        }
        
        static func inMinutes(_ number: Any?) -> String {
            orElseForever(number, unit: MINUTES)
        }
        
    }
    
    class Screen {
        
        static var frame: NSRect? {
            NSScreen.main?.frame
        }
        
        static var hasNotch: Bool {
            guard #available(macOS 12, *) else { return false }
            return NSScreen.main?.safeAreaInsets.top != 0
        }
        
        static var width: CGFloat? {
            NSScreen.main?.frame.size.width ?? nil
        }
        
        static var height: CGFloat? {
            NSScreen.main?.frame.size.height ?? nil
        }
        
        static var maxWidth: CGFloat? {
            let screens = NSScreen.screens
            var maxWidth: CGFloat?
            
            for screen in screens {
                let screenFrame = screen.visibleFrame
                if maxWidth == nil || screenFrame.size.width > maxWidth ?? 0 {
                    maxWidth = screenFrame.size.width
                }
            }
            
            return maxWidth
        }
        
        static var maxHeight: CGFloat? {
            let screens = NSScreen.screens
            var maxHeight: CGFloat?
            
            for screen in screens {
                let screenFrame = screen.visibleFrame
                if maxHeight == nil || screenFrame.size.height > maxHeight ?? 0 {
                    maxHeight = screenFrame.size.height
                }
            }
            
            return maxHeight
        }
        
    }
    
    class Keyboard {
        
        static var command: Bool {
            NSEvent.modifierFlags.contains(.command)
        }
        
        static var option: Bool {
            NSEvent.modifierFlags.contains(.option)
        }
        
        static var shift: Bool {
            NSEvent.modifierFlags.contains(.shift)
        }
        
        static var modifiers: Bool {
            (Data.modifiers.command && command)
            || (Data.modifiers.option && option)
            || (Data.modifiers.command && command)
        }
        
    }
    
    class Mouse {
        
        static var none: Bool {
            NSEvent.pressedMouseButtons == 0;
        }
        
        static var left: Bool {
            NSEvent.pressedMouseButtons & 0x1 == 1
        }
        
        static func inside(
            _ rect: NSRect?
        ) -> Bool {
            rect?.contains(NSEvent.mouseLocation) ?? false
        }
        
    }
    
}
