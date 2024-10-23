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
let delegate = AbyssalApp() // allocate

// MARK: - Application Menu

let menu = NSMenu()

// MARK: - Run

app.delegate = delegate
app.mainMenu = menu
app.run()
