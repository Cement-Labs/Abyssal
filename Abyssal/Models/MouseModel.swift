//
//  MouseModel.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import AppKit

@Observable
class MouseModel {
    static var shared = MouseModel()
    
    var none: Bool {
        NSEvent.pressedMouseButtons == 0;
    }
    
    var left: Bool {
        NSEvent.pressedMouseButtons & 0x1 == 1
    }
    
    var dragging: Bool {
        KeyboardModel.shared.command && left
    }
    
    func inside(
        _ rect: NSRect?
    ) -> Bool {
        rect?.contains(NSEvent.mouseLocation) ?? false
    }
}
