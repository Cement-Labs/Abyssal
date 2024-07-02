//
//  ApplicationMenuManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/7/2.
//

import AppKit

struct ApplicationMenuManager {
    static func set(_ menu: NSMenu?) {
        NSApp.mainMenu = menu
        
        // Do this
        NSMenu.setMenuBarVisible(false)
        NSMenu.setMenuBarVisible(true)
    }
}
