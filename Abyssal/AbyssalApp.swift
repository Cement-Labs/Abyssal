//
//  AbyssalApp.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa
import SwiftUI
import AppKit
import Defaults
import LaunchAtLogin

let repository = "Cement-Labs/Abyssal"

class AbyssalApp: NSObject, NSApplicationDelegate {
    static var shared: AbyssalApp? {
        NSApplication.shared.delegate as? AbyssalApp
    }
    
    static var isActive: Bool = false
    
    static let statusBarController = StatusBarController()

    // MARK: - Event Monitors
    
    static var mouseEventMonitor: EventMonitor?
    
    // MARK: - Application Methods
    
    func applicationDidFinishLaunching(
        _ aNotification: Notification
    ) {
        // Set activation policy to `prohibited` after launched
        ActivationPolicyManager.set(.prohibited, asFallback: true)
        
        // Fetch latest version
        VersionModel.shared.fetchLatest()
        
        Self.statusBarController.function()
    }
    
    func applicationWillTerminate(
        _ aNotification: Notification
    ) {
    }
    
    func applicationSupportsSecureRestorableState(
        _ app: NSApplication
    ) -> Bool {
        true
    }
    
    func applicationWillBecomeActive(_: Notification) {
        AbyssalApp.isActive = true
    }
    
    func applicationWillResignActive(_: Notification) {
        Self.isActive = false
    }
}

extension AbyssalApp: NSPopoverDelegate {
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        true
    }
}

extension AbyssalApp {
    @objc func quit(
        _ sender: Any?
    ) {
        NSApplication.shared.terminate(sender)
    }
    
    // MARK: - Toggles
    
    @objc func toggle(
        _ sender: Any?
    ) {
        guard sender as? NSStatusBarButton == Self.statusBarController.head.button else {
            toggleActive(sender)
            return
        }
        
        if KeyboardModel.shared.option {
            openSettings(sender)
        } else {
            if let event = NSApp.currentEvent, event.type == .rightMouseUp {
                openSettings(sender)
            } else {
                toggleActive(sender)
            }
        }
    }
    
    @objc func toggleActive(
        _ sender: Any?
    ) {
        Self.statusBarController.function()
        
        guard !(Self.statusBarController.idling.hidden || Self.statusBarController.idling.alwaysHidden) else {
            Self.statusBarController.unidleHiddenArea()
            return
        }
        
        if Defaults[.isStandby] {
            Self.statusBarController.restore()
        } else {
            Self.statusBarController.standby()
        }
    }
    
    @objc func openSettings(
        _ sender: Any?
    ) {
        LuminareManager.open()
    }
    
    @objc func closeSettings(
        _ sender: Any?
    ) {
        LuminareManager.fullyClose()
    }
}
