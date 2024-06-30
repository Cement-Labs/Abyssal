//
//  KeyboardShortcuts+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/30.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleCollapse = Self("toggleCollapse", default: .init(.backtick, modifiers: [.shift, .command]))
}
