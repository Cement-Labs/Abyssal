//
//  InvisiblePanel.swift
//  Abyssal
//
//  Created by KrLite on 2024/4/27.
//

import Foundation
import AppKit

class InvisiblePanel: NSPanel {
    override var canBecomeKey: Bool {
        true
    }
}
