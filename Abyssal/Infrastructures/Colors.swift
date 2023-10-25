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
    
    public static let background = getOrClear("Background")
    
    public static let border = getOrClear("Border")
    
    public static let borderSecondary = getOrClear("BorderSecondary")
    
    class Translucent {
        
        public static let opacity = 0.07
        
        public static var danger: NSColor {
            Opaque.danger.withAlphaComponent(opacity)
        }
        
        public static var safe: NSColor {
            Opaque.safe.withAlphaComponent(opacity)
        }
        
        public static var accent: NSColor {
            Opaque.accent.withAlphaComponent(opacity)
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
