//
//  ScreenManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import AppKit
import Defaults

struct ScreenManager {
    static var main: NSScreen? {
        .main
    }
    
    static var frame: NSRect {
        main?.frame ?? .zero
    }
    
    static var hasNotch: Bool {
        main?.safeAreaInsets.top != 0
    }
    
    static var width: CGFloat {
        frame.size.width
    }
    
    static var height: CGFloat {
        frame.size.height
    }
    
    static var origin: CGPoint {
        frame.origin
    }
    
    static var maxWidth: CGFloat {
        let screens = NSScreen.screens
        var maxWidth: CGFloat = 0
        
        for screen in screens {
            let screenFrame = screen.visibleFrame
            if screenFrame.size.width > maxWidth {
                maxWidth = screenFrame.size.width
            }
        }
        
        return maxWidth
    }
    
    static var maxHeight: CGFloat {
        let screens = NSScreen.screens
        var maxHeight: CGFloat = 0
        
        for screen in screens {
            let screenFrame = screen.visibleFrame
            if screenFrame.size.height > maxHeight {
                maxHeight = screenFrame.size.height
            }
        }
        
        return maxHeight
    }
    
    static var menuBarLeftEdge: CGFloat {
        let origin = origin
        let setting = Defaults[.screenSettings].main
        
        if hasNotch && setting.respectNotch {
            // Respect notch area on screens with notches
            let notchWidth = 250.0
            return origin.x + width / 2.0 + notchWidth / 2.0
        } else {
            switch setting.deadZone {
            case .percentage(let percentage):
                let rightEdge = AppDelegate.shared?.statusBarController.edge ?? width
                return origin.x + 50 + (rightEdge - 50) * (percentage / 100) // Apple icon + app name should be at least 50 pixels wide.
            case .pixel(let pixel):
                return pixel
            }
        }
    }
}
