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
    static var isActive: Bool = false

    static let statusBarController = StatusBarController()

    // MARK: - Event Monitors

    static var mouseEventMonitor: EventMonitor?

    // MARK: - Application Methods

    func applicationDidFinishLaunching(
        _ aNotification: Notification
    ) {
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

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows: Bool) -> Bool {
        openSettingsSelector(sender)
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        closeSettingsSelector(sender)
        return false
    }

    func applicationWillBecomeActive(_: Notification) {
        Self.isActive = true
        Self.statusBarController.function()
    }

    func applicationWillResignActive(_ notification: Notification) {
        Self.isActive = false
        Self.statusBarController.function()
    }
}

extension AbyssalApp {
    func openSettings(
        with: LuminareTab = .appearance
    ) {
        ActivationPolicyManager.set(.regular)
        NSApp.activate()
        LuminareManager.open(with: with)
    }

    func closeSettings() {
        LuminareManager.close()
        ActivationPolicyManager.setToFallback()
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

        guard !LuminareManager.isOpened else {
            toggleStandby(sender)
            return
        }

        guard sender == Self.statusBarController.head.button else {
            toggleStandby(sender)
            return
        }

        if KeyboardModel.shared.option {
            openSettingsSelector(sender)
        } else {
            if let event = NSApp.currentEvent, event.type == .rightMouseUp {
                if let item = statusItems.filter({ $0.button == sender }).first {
                    // opens menu
                    item.menu = NSHostingMenu(rootView: MenuBarMenuView())
                    sender.performClick(nil)
                    item.menu = nil
                }
            } else {
                toggleStandby(sender)
            }
        }
    }

    @objc func toggleStandby(
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

    @objc func openSettingsSelector(
        _ sender: Any?
    ) {
        openSettings()
    }

    @objc func closeSettingsSelector(
        _ sender: Any?
    ) {
        closeSettings()
    }
}
