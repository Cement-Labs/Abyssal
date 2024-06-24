//
//  KeyboardManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import AppKit
import Defaults

struct KeyboardManager {
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
    
    static var triggers: Bool {
        Defaults[.modifierMode].triggers(input: ModifiersAttribute.fromFlags(NSEvent.modifierFlags))
    }
}
