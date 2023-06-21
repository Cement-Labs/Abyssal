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
	
	let popover: NSPopover = NSPopover()
	
	let statusBarController = StatusBarController()
	
	// MARK: - Event Monitors
	
	var mouseEventMonitor: EventMonitor?
	
	// MARK: - Application Methods
	
	func applicationDidFinishLaunching(
		_ aNotification: Notification
	) {
		popover.contentViewController = ViewController.freshController()
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
	
	// MARK: - Toggles
	
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
		guard !(statusBarController.idling || statusBarController.idlingAlwaysHideArea) else {
			statusBarController.unidle()
			return
		}
		
		if Data.collapsed {
			statusBarController.uncollapse()
		} else {
			statusBarController.collapse()
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
		
		mouseEventMonitor?.start()
	}
	
	func closePopover(
		_ sender: Any?
	) {
		popover.performClose(sender)
		
		mouseEventMonitor?.stop()
	}
	
}
