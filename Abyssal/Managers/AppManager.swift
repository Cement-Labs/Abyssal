//
//  AppManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/26.
//

import Foundation
import AppKit

@Observable
class AppManager {
    static var frontmost: NSRunningApplication {
        NSWorkspace.shared.frontmostApplication ?? .current
    }
    
    static var fronsmostName: String {
        frontmost.localizedName ?? String(frontmost.hashValue)
    }
}
