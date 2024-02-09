//
//  Helper.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import ApplicationServices
import AppKit
import Defaults

struct Helper {
    
    static let repoPath = "NNN-Studio/Abyssal"
    
    static let urlSourceCode = URL(string: "https://github.com/\(repoPath)")!
    
    static let urlRelease = URL(string: "https://github.com/\(repoPath)/releases")!
    
    static let urlReleaseTags = URL(string: "https://api.github.com/repos/\(repoPath)/tags")!
    
    static var lerpThreshold: CGFloat {
        guard let width = ScreenHelper.width else { return 75 }
        return width / 25
    }
    
    static var lerpRatio: CGFloat {
        let baseValue = 0.42
        return baseValue * (KeyboardHelper.shift ? 0.25 : 1) // Slow down when shift key is down
    }
    
    static var menuBarLeftEdge: CGFloat {
        let origin = ScreenHelper.origin ?? NSPoint.zero
        guard let width = ScreenHelper.width else { return origin.x }
        
        if ScreenHelper.hasNotch {
            let notchWidth = 250.0
            return origin.x + width / 2.0 + notchWidth / 2.0
        } else {
            let rightEdge = AppDelegate.instance?.statusBarController.edge ?? width
            return origin.x + 50 + (rightEdge - 50) * Defaults[.deadZone].percentage // Apple icon + App name should be at least 50 pixels wide.
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
        let diff = b - a
        
        return a + log10ClampWithThreshold(diff, threshold: lerpThreshold) * ratio
    }
    
    static func log10ClampWithThreshold(
        _ x: CGFloat,
        threshold: CGFloat
    ) -> CGFloat {
        if x < -threshold {
            return -(threshold + log10(-x / threshold) * threshold)
        } else if x > threshold {
            return threshold + log10(x / threshold) * threshold
        } else {
            return x
        }
    }
    
    static func switchToTheme(
        _ index: Int
    ) {
        Defaults[.theme] = Themes.themes[index]
        
        AppDelegate.instance?.statusBarController.map()
        AppDelegate.instance?.statusBarController.startFunctionalTimers()
    }
    
}

struct VersionHelper {
    
    static let checkNewVersionsTask = URLSession.shared.dataTask(with: Helper.urlReleaseTags) { (data, response, error) in
        guard let data = data else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                let tags = json.sorted { (v1, v2) -> Bool in
                    let name1 = v1["name"] as? String ?? ""
                    let name2 = v2["name"] as? String ?? ""
                    
                    return name2.compare(name1, options: .numeric) == .orderedAscending
                }
                
                if let latestTag = tags.first?["name"] as? String {
                    VersionHelper.latestTag = latestTag
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static var version: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    private static var _latestTag: String = ""
    
    static var latestTag: String {
        get {
            _latestTag
        }
        
        set(version) {
            let regex = /\d+\.\d+\.\d+/
            let nsVersion = version
            
            if let match = nsVersion.firstMatch(of: regex) {
                VersionHelper._latestTag = String(match.output)
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
    
}

struct ScreenHelper {
    
    static var frame: NSRect? {
        NSScreen.main?.frame
    }
    
    static var hasNotch: Bool {
        return NSScreen.main?.safeAreaInsets.top != 0
    }
    
    static var width: CGFloat? {
        NSScreen.main?.frame.size.width ?? nil
    }
    
    static var height: CGFloat? {
        NSScreen.main?.frame.size.height ?? nil
    }
    
    static var origin: CGPoint? {
        frame?.origin
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

struct KeyboardHelper {
    
    static var shift: Bool {
        NSEvent.modifierFlags.contains(.shift)
    }
    
    static var control: Bool {
        NSEvent.modifierFlags.contains(.control)
    }
    
    static var option: Bool {
        NSEvent.modifierFlags.contains(.option)
    }
    
    static var command: Bool {
        NSEvent.modifierFlags.contains(.command)
    }
    
    static var modifiers: Bool {
        (Defaults[.modifiers].control && control)
        || (Defaults[.modifiers].option && option)
        || (Defaults[.modifiers].command && command)
    }
    
}

struct MouseHelper {
    
    static var none: Bool {
        NSEvent.pressedMouseButtons == 0;
    }
    
    static var left: Bool {
        NSEvent.pressedMouseButtons & 0x1 == 1
    }
    
    static var dragging: Bool {
        KeyboardHelper.command && left
    }
    
    static func inside(
        _ rect: NSRect?
    ) -> Bool {
        rect?.contains(NSEvent.mouseLocation) ?? false
    }
    
}
