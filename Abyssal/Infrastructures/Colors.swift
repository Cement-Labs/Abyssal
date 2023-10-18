//
//  Colors.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/12.
//

import Foundation
import AppKit

class Colors {
    
    static func getOrClear(
        _ name: String
    ) -> NSColor {
        NSColor(named: NSColor.Name("Colors/\(name)")) ?? NSColor.clear
    }
    
    public static let BACKGROUND = getOrClear("Background")
    
    public static let BORDER = getOrClear("Border")
    
    public static let BORDER_SECONDARY = getOrClear("BorderSecondary")
    
    class Translucent {
        
        public static let OPACITY = 0.07
        
        public static var danger: NSColor {
            Opaque.danger.withAlphaComponent(OPACITY)
        }
        
        public static var safe: NSColor {
            Opaque.safe.withAlphaComponent(OPACITY)
        }
        
        public static var accent: NSColor {
            Opaque.accent.withAlphaComponent(OPACITY)
        }
        
    }
    
    class Opaque {
        
        public static var danger: NSColor {
            NSColor.systemRed
        }
        
        public static var safe: NSColor {
            NSColor.systemGreen
        }
        
        public static var accent: NSColor {
            NSColor.controlAccentColor
        }
        
    }
    
}
