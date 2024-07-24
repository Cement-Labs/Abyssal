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

let repository = "Cement-Labs/Abyssal"

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
        
        // Fetch latest version
        VersionModel.shared.fetchLatest()
        
        popover.behavior = .applicationDefined
        popover.delegate = self
        
        mouseEventMonitor = EventMonitor(
            mask: [.leftMouseDown,
                   .rightMouseDown]
        ) { [weak self] event in
            if let strongSelf = self {
                if strongSelf.popover.isShown {
                    // Close popover when clicked outside
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
    
    @objc func escapeFromOverridingMenuBar(
        _ sender: Any?
    ) {
        if popover.isShown {
            closePopover(sender)
        } else {
            ActivationPolicyManager.set(.prohibited, asFallback: true)
            statusBarController.unidleHideArea()
        }
    }
    
    // MARK: - Toggles
    
    @objc func toggle(
        _ sender: Any?
    ) {
        guard sender as? NSStatusBarButton == AppDelegate.shared?.statusBarController.head.button else {
            toggleActive(sender)
            return
        }
        
        if KeyboardModel.shared.option {
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
            // Initialize view controller
            let controller = SettingsViewController()
            controller.view = NSHostingView(rootView: SettingsView())
            popover.contentViewController = controller
            
            // Pre-initialize view frame
            controller.initializeFrame()
            
            // Position popover
            
            let buttonRect = button.convert(button.bounds, to: nil)
            let screenRect = button.window!.convertToScreen(buttonRect)
            
            let invisiblePanel = NSPanel(
                contentRect: NSMakeRect(0, 0, 1, 5),
                styleMask: [.borderless],
                backing: .buffered,
                defer: false,
                screen: .main
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
            
            DispatchQueue.main.async(popover) {
                controller.viewWillAppear()
                controller.view.window?.makeKeyAndOrderFront(nil)
                controller.viewDidAppear()
            }
        }
        
        mouseEventMonitor?.start()
    }
    
    func closePopover(
        _ sender: Any?
    ) {
        if let controller = popover.contentViewController {
            DispatchQueue.main.async(popover) {
                controller.viewWillDisappear()
                self.popover.close() // Force it to close, thus closing all nested popovers
                controller.viewDidDisappear()
                
                DispatchQueue.main.asyncAfter(self.popover, deadline: .now() + 0.2) {
                    self.popover.contentViewController = nil
                }
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
}
