//
//  AppDelegate.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa
import AppKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
	let popover: 			NSPopover = NSPopover()
    
	let statusBarController = StatusBarController()
	
	// MARK: - Event Monitors
    
    var mouseClickEventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(
        _ aNotification: Notification
    ) {
        statusBarController.setup()
        
        popover.contentViewController 			= ViewController.freshController()
        
        mouseClickEventMonitor = EventMonitor(
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
        // Insert code here to tear down your application
        
        statusBarController.terminate()
    }
    
    func applicationSupportsSecureRestorableState(
        _ app: NSApplication
    ) -> Bool {
        return true
    }
	
	@objc func toggle(
		_ sender: NSButton
	) {
		if Helper.Keyboard.option {
			togglePopover(sender)
		} else {
			toggleCollapse(sender)
		}
	}
	
	@objc func toggleCollapse(
		_ sender: NSButton
	) {
		if statusBarController.collapsed {
			statusBarController.disableCollapse()
		} else {
			statusBarController.enableCollapse()
		}
	}
    
    @objc func togglePopover(
        _ sender: NSButton
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
                preferredEdge: 	NSRectEdge.minY
            )
			
			if let window = popover.contentViewController?.view.window {
				// Activate popover
				window.becomeKey()
			}
        }
        
        mouseClickEventMonitor?.start()
    }
    
    func closePopover(
        _ sender: Any?
    ) {
        popover.performClose(
            sender
        )
        
        mouseClickEventMonitor?.stop()
    }
    
}
