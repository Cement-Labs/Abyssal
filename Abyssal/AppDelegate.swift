//
//  AppDelegate.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa
import AppKit
import Defaults
import LaunchAtLogin

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static var instance: AppDelegate? {
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
        popover.contentViewController = MenuController.freshController()
        popover.behavior = .transient
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
        guard sender as? NSStatusBarButton == AppDelegate.instance?.statusBarController.head.button else {
            toggleCollapse(sender)
            return
        }
        
        if KeyboardHelper.option {
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
        
        if Defaults[.isCollapsed] {
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
            
            popover.contentViewController?.view.window?.makeKeyAndOrderFront(nil)
            NSRunningApplication.current.activate()
        }
        
        mouseEventMonitor?.start()
    }
    
    func closePopover(
        _ sender: Any?
    ) {
        popover.performClose(sender)
        
        mouseEventMonitor?.stop()
        statusBarController.startFunctionalTimers()
        AppDelegate.instance?.statusBarController.triggerIgnoring()
    }
    
}

func runTasks() {
    Task {
        for await value in Defaults.updates(.launchAtLogin) {
            LaunchAtLogin.isEnabled = value
        }
    }
}
