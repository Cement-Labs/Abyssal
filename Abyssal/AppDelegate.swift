//
//  AppDelegate.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa
import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let popover: NSPopover = NSPopover()
    
    let statusBarController = StatusBarController()
    
    // MARK: - Event Monitors
    
    var mouseEventMonitor: EventMonitor?
    
    // MARK: - Application Methods
    
    func applicationDidFinishLaunching(
        _ aNotification: Notification
    ) {
        Data.registerDefaults()
        
        popover.contentViewController = MenuController.freshController()
        Helper.CHECK_NEWER_VERSION_TASK.resume()
        
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
        return true
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
        if Helper.Keyboard.option {
            togglePopover(sender)
        } else {
            if let event = NSApp.currentEvent, event.type == .rightMouseUp {
                togglePopover(sender)
            } else {
                toggleCollapse(sender)
            }
        }
    }
    
    @objc func toggleCollapse(
        _ sender: Any?
    ) {
        statusBarController.startFunctionalTimers()
        
        guard !(statusBarController.idling.hide || statusBarController.idling.alwaysHide) else {
            statusBarController.unidleHideArea()
            return
        }
        
        if Data.collapsed {
            statusBarController.uncollapse()
        } else {
            statusBarController.collapse()
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
            popover.show(
                relativeTo: 	button.bounds,
                of: 			button,
                preferredEdge: 	.maxX
            )
            
            if let window = popover.contentViewController?.view.window {
                // Activate popover
                window.becomeKey()
            }
        }
        
        mouseEventMonitor?.start()
    }
    
    func closePopover(
        _ sender: Any?
    ) {
        popover.performClose(sender)
        
        mouseEventMonitor?.stop()
        statusBarController.startFunctionalTimers()
    }
    
}
