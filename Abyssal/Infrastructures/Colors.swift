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
        
        public static let DANGER = Colors.getOrClear("Translucent/Danger")
        
        public static let HYPER = Colors.getOrClear("Translucent/Hyper")
        
        public static let MAGIC = Colors.getOrClear("Translucent/Magic")
        
        public static let SAFE = Colors.getOrClear("Translucent/Safe")
        
        public static let UNSAFE = Colors.getOrClear("Translucent/Unsafe")
        
    }
    
    class Opaque {
        
        public static let DANGER = Colors.getOrClear("Opaque/Danger")
        
        public static let HYPER = Colors.getOrClear("Opaque/Hyper")
        
        public static let MAGIC = Colors.getOrClear("Opaque/Magic")
        
        public static let SAFE = Colors.getOrClear("Opaque/Safe")
        
        public static let UNSAFE = Colors.getOrClear("Opaque/Unsafe")
        
    }
    
}
