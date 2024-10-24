//
//  main.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/28.
//

// https://stackoverflow.com/a/68502031/23452915

import AppKit
import SwiftUI

// MARK: - Application

let app = NSApplication.shared
let abyssal = AbyssalApp() // allocate

// MARK: - Application Menu

let appMainMenu = NSHostingMenu(rootView: ApplicationMenuView())

// MARK: - Run

app.delegate = abyssal
app.mainMenu = appMainMenu
app.run()
