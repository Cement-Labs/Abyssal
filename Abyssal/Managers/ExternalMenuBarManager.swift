//
//  ExternalMenuBarManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/30.
//

import Foundation
import AppKit

class ExternalMenuBarItem {
    let windowInfo: WindowInfo
    
    init(windowInfo: WindowInfo) {
        self.windowInfo = windowInfo
    }
    
    var pid: pid_t {
        windowInfo.ownerProcessID
    }
    
    var windowNumber: Int {
        windowInfo.windowNumber
    }
    
    var bounds: NSRect {
        windowInfo.bounds
    }
    
    var windowsNear: [WindowInfo] {
        windowInfo
            .processRelatedWindows
            .filter(\.isOnscreen)
            .filter { $0.isPlacingNear(bounds, edge: .maxY) }
    }
    
    var newWindowsNear: [WindowInfo] {
        windowsNear
            .filter { !cachedWindowNumbersNear.contains($0.windowNumber) }
    }
    
    private var cachedWindowNumbersNear: [Int] {
        get {
            ExternalMenuBarManager.cachedWindowNumbersNear[windowNumber] ?? []
        }
        
        set(windowNumbersNear) {
            ExternalMenuBarManager.cachedWindowNumbersNear[windowNumber] = windowNumbersNear
        }
    }
    
    func cache() {
        cachedWindowNumbersNear = windowsNear.map(\.windowNumber)
    }
}

struct ExternalMenuBarManager {
    fileprivate static var cachedWindowNumbersNear: [Int: [Int]] = [:]
    
    static var menuBarWindowInfos: [WindowInfo] {
        WindowInfo.allOnScreenWindows
            .filter(\.isStatusMenuItem)
            .filter { !$0.isFromAbyssal }
    }
    
    static var menuBarItems: [ExternalMenuBarItem] {
        menuBarWindowInfos
            .map(ExternalMenuBarItem.init)
    }
}
