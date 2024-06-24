//
//  ScreenManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import AppKit
import Defaults

struct ScreenManager {
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
    
    // TODO: Update this.
    static var menuBarLeftEdge: CGFloat {
        let origin = origin ?? NSPoint.zero
        guard let width = width else { return origin.x }
        
        if hasNotch {
            let notchWidth = 250.0
            return origin.x + width / 2.0 + notchWidth / 2.0
        } else {
            let rightEdge = AppDelegate.shared?.statusBarController.edge ?? width
            return origin.x + 50 + (rightEdge - 50) * Defaults[.deadZone].percentage // Apple icon + app name should be at least 50 pixels wide.
        }
    }
}
