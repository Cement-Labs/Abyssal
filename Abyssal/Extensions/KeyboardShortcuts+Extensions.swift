//
//  KeyboardShortcuts+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/30.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleActive = Self("toggleActive", default: .init(.backtick, modifiers: [.control]))
    static let toggleMenuBarOverride = Self("toggleMenuBarOverride", default: .init(.backtick, modifiers: [.control, .option]))
}
