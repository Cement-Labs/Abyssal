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
        // set activation policy to `prohibited` after launched
        ActivationPolicyManager.set(.prohibited, asFallback: true)
        
        // fetch latest version
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
        guard let sender = sender as? NSStatusBarButton else {
            return
        }
        
        guard sender == Self.statusBarController.head.button else {
            toggleActive(sender)
            return
        }
        
        if KeyboardModel.shared.option {
            openSettings(sender)
        } else {
            if let event = NSApp.currentEvent, event.type == .rightMouseUp {
                if let item = statusItems.filter({ $0.button == sender }).first {
                    // opens menu
                    item.menu = NSHostingMenu(rootView: MenuBarMenuView())
                    sender.performClick(nil)
                    item.menu = nil
                }
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
        AbyssalApp.statusBarController.function()
    }
    
    @objc func closeSettings(
        _ sender: Any?
    ) {
        LuminareManager.close()
        AbyssalApp.statusBarController.function()
    }
}
