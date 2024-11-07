//
//  KeyboardModel.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import AppKit
import Defaults

@Observable
class KeyboardModel {
    static var shared = KeyboardModel()

    var shift: Bool {
        NSEvent.modifierFlags.contains(.shift)
    }

    var control: Bool {
        NSEvent.modifierFlags.contains(.control)
    }

    var option: Bool {
        NSEvent.modifierFlags.contains(.option)
    }

    var command: Bool {
        NSEvent.modifierFlags.contains(.command)
    }

    var triggers: Bool {
        Defaults[.modifierCompose].triggers(input: Modifier.fromFlags(NSEvent.modifierFlags))
    }
}
