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

let emptyMenu = NSMenu() // Without any siblings

// MARK: - Run

app.delegate = delegate
app.mainMenu = emptyMenu
app.run()
