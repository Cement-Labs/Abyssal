//
//  ApplicationMenuManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/7/2.
//

import AppKit

struct ApplicationMenuManager {
    static func apply(_ menu: NSMenu?) {
        NSApp.mainMenu = menu
    }
}
