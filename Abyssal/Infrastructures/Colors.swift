//
//  Colors.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/12.
//

import Foundation
import AppKit

@available(*, deprecated)
class Colors {
    public static var isDarkMode: Bool {
        NSApplication.shared.effectiveAppearance.bestMatch(from: [.darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark]) == .darkAqua
    }
    
    public static var thinBackgroundColor: NSColor {
        (isDarkMode ? NSColor.white : NSColor.black).withAlphaComponent(isDarkMode ? 0.08 : 0.06)
    }
    
    class Translucent {
        public static let opacity = 0.175
        
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
