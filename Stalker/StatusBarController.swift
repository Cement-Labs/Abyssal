//
//  StatusBarController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
    
    // MARK: Constants
    
    static let collapseDisabledWidth: CGFloat = 20
    
    static let collapseEnabledWidth: CGFloat = 10000
    
    // MARK: Icons
    
    private static let separator = NSStatusBar.system.statusItem(withLength: collapseDisabledWidth)
    
    // MARK: Methods
    
    static func setupSeparator() {
        if let button = separator.button {
            button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        }
    }
    
    static func enableCollapse() {
        separator.length = StatusBarController.collapseEnabledWidth
    }
    
    static func disableCollapse() {
        separator.length = StatusBarController.collapseDisabledWidth
    }
    
}
