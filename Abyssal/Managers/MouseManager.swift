//
//  MouseManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import AppKit

struct MouseManager {
    static var none: Bool {
        NSEvent.pressedMouseButtons == 0;
    }
    
    static var left: Bool {
        NSEvent.pressedMouseButtons & 0x1 == 1
    }
    
    static var dragging: Bool {
        KeyboardManager.command && left
    }
    
    static func inside(
        _ rect: NSRect?
    ) -> Bool {
        rect?.contains(NSEvent.mouseLocation) ?? false
    }
}
