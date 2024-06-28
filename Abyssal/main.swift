//
//  main.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/28.
//

import AppKit

// https://stackoverflow.com/a/68502031/23452915
let app = NSApplication.shared
let delegate = AppDelegate() // Allocate
app.delegate = delegate
app.run()
