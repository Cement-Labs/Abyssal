//
//  StatusBarController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
    
    var collapsed: Bool = false
    
    var timer: Timer?
    
    // MARK: Constants
    
    static let collapseDisabledLength: CGFloat  = 2
    
    static let collapseIgnoredLength: CGFloat   = 32
    
    static let collapseEnabledLength: CGFloat   = 10000
    
    static let lerpRatio: CGFloat = 0.079
    
    // MARK: Icons
    
    let separator: NSStatusItem = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.variableLength
    )
    
    let main: NSStatusItem = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.variableLength
    )
    
    // MARK: Methods
    
    func setup() {
        if let button = self.separator.button {
            button.image    = NSImage(named:NSImage.Name("SepWave"))
            button.action   = #selector(AppDelegate.toggleCollapse(_:))
        }
        separator.length = 0
        
        if let button = self.main.button {
            button.image    = NSImage(named:NSImage.Name("SepSpace"))
            button.action   = #selector(AppDelegate.togglePopover(_:))
        }
        main.length = 0
        
        startTimer()
    }
    
    func enableCollapse() {
        self.collapsed = true
    }
    
    func disableCollapse() {
        self.collapsed = false
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.01,
            repeats: true
        ) { [weak self] _ in
            self?.lerp()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func lerp() {
        do {
            let length = self.separator.length
            var enabledLength = StatusBarController.collapseEnabledLength
            
            if var screenWidth = Helper.screenWidth() {
                if Helper.hasNotch() {
                    screenWidth /= 2.0
                }
                enabledLength = screenWidth
            }
            
            self.separator.length = Helper.lerp(
                a: length,
                b: self.collapsed ? enabledLength : StatusBarController.collapseDisabledLength,
                ratio: StatusBarController.lerpRatio
            )
        }
        
        do {
            let length = self.main.length
            self.main.length = Helper.lerp(
                a: length,
                b: self.collapsed ? StatusBarController.collapseIgnoredLength : StatusBarController.collapseDisabledLength,
                ratio: StatusBarController.lerpRatio
            )
        }
    }
    
}
