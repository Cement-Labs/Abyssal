//
//  AppDelegate.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa
import SwiftUI
import AppKit
import Defaults
import LaunchAtLogin

let repository = "NNN-Studio/Abyssal"//"Cement-Labs/Abyssal"

//@main
class AppDelegate: NSObject, NSApplicationDelegate {
    static var shared: AppDelegate? {
        NSApplication.shared.delegate as? AppDelegate
    }
    
    let popover: NSPopover = NSPopover()
    
    let statusBarController = StatusBarController()
    
    // MARK: - Event Monitors
    
    var mouseEventMonitor: EventMonitor?
    
    // MARK: - Application Methods
    
    func applicationDidFinishLaunching(
        _ aNotification: Notification
    ) {
        // Set activation policy to `prohibited` after launched
        ActivationPolicyManager.set(.prohibited, asFallback: true)
        
        let controller = SettingsViewController()
        controller.view = NSHostingView(rootView: SettingsView())
        popover.contentViewController = controller
        
        // Fetch latest version
        VersionManager.fetchLatest()
        
        // Pre-initialize view frame
        controller.initializeFrame()
        
        popover.behavior = .applicationDefined
        popover.delegate = self
        
        mouseEventMonitor = EventMonitor(
            mask: [.leftMouseDown,
                   .rightMouseDown]
        ) { [weak self] event in
            if let strongSelf = self {
                if strongSelf.popover.isShown {
                    strongSelf.closePopover(event)
                }
            }
        }
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
}

extension AppDelegate: NSPopoverDelegate {
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        true
    }
}

extension AppDelegate {
    @objc func quit(
        _ sender: Any?
    ) {
        NSApplication.shared.terminate(sender)
    }
    
    // MARK: - Toggles
    
    @objc func toggle(
        _ sender: Any?
    ) {
        guard sender as? NSStatusBarButton == AppDelegate.shared?.statusBarController.head.button else {
            toggleActive(sender)
            return
        }
        
        if KeyboardManager.option {
            togglePopover(sender)
        } else {
            if let event = NSApp.currentEvent, event.type == .rightMouseUp {
                togglePopover(sender)
            } else {
                toggleActive(sender)
            }
        }
    }
    
    @objc func toggleActive(
        _ sender: Any?
    ) {
        statusBarController.function()
        
        guard !(statusBarController.idling.hide || statusBarController.idling.alwaysHide) else {
            statusBarController.unidleHideArea()
            return
        }
        
        if Defaults[.isActive] {
            statusBarController.deactivate()
        } else {
            statusBarController.activate()
        }
    }
    
    @objc func togglePopover(
        _ sender: Any?
    ) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(
        _ sender: Any?
    ) {
        if let button = statusBarController.head.button ?? sender as? NSButton {
            // Position popover
            
            let buttonRect = button.convert(button.bounds, to: nil)
            let screenRect = button.window!.convertToScreen(buttonRect)
            
            let invisiblePanel = NSPanel(
                contentRect: NSMakeRect(0, 0, 1, 5),
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
            invisiblePanel.isFloatingPanel = true
            invisiblePanel.alphaValue = 0

            invisiblePanel.setFrameOrigin(NSPoint(
                x: screenRect.maxX,
                y: screenRect.maxY
            ))
            invisiblePanel.makeKeyAndOrderFront(nil)
            
            popover.show(
                relativeTo: 	invisiblePanel.contentView!.frame,
                of: 			invisiblePanel.contentView!,
                preferredEdge: 	.maxY
            )
            
            // Set to foreground activation policy
            
            let overridesMenuBar = Defaults[.autoOverridesMenuBarEnabled]
            let activationPolicy: NSApplication.ActivationPolicy = overridesMenuBar ? .regular : .accessory
            
            Defaults[.menuBarOverride].apply()
            ActivationPolicyManager.set(activationPolicy, asFallback: true)
            NSApp.activate()
            
            DispatchQueue.main.async {
                self.popover.contentViewController?.viewWillAppear()
                self.popover.contentViewController?.view.window?.makeKeyAndOrderFront(nil)
                self.popover.contentViewController?.viewDidAppear()
            }
        }
        
        mouseEventMonitor?.start()
    }
    
    func closePopover(
        _ sender: Any?
    ) {
        DispatchQueue.main.async {
            self.popover.contentViewController?.viewWillDisappear()
            self.popover.close() // Force it to close, thus closing all nested popovers
            self.popover.contentViewController?.viewDidDisappear()
        }
        
        // Restore activation policy
        
        // 1. Set to `accessory` after closed to prevent the popover from not being able to open properly again
        ActivationPolicyManager.set(.accessory, asFallback: true, deadline: .now() + 0.2) {
            // 2. Set to `prohibited` asynchronously to order out
            ActivationPolicyManager.set(.prohibited, asFallback: true, deadline: .now())
        }
        
        // Stop functioning
        
        mouseEventMonitor?.stop()
        statusBarController.function()
        statusBarController.triggerIgnoring()
    }
}
