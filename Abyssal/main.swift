//
//  main.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/28.
//

// https://stackoverflow.com/a/68502031/23452915

import AppKit

// MARK: - Application

let app = NSApplication.shared
let delegate = AppDelegate() // Allocate

// MARK: - Application Menu

var appMenu = NSMenu()

do {
    let appMenuMain = NSMenu(title: Bundle.main.appName)
    appMenuMain.addItem(.init(
        title: .init(localized: "Quit"),
        action: #selector(delegate.quit(_:)), keyEquivalent: "q"
    ))
    
    appMenu.addItem({
        let item = NSMenuItem()
        item.submenu = appMenuMain
        return item
    }())
}

// MARK: - Run

app.delegate = delegate
app.mainMenu = appMenu
app.run()
