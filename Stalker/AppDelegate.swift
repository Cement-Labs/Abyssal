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
    
    let popover = NSPopover()
    
    static let statusBarController = StatusBarController()
    
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(
        _ aNotification: Notification
    ) {
        AppDelegate.statusBarController.setup()
        
        popover.contentViewController = ViewController.freshController()
        
        eventMonitor = EventMonitor(
            mask: [.leftMouseDown,
                   .rightMouseDown]
        ) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(event)
            }
        }
    }
    
    
    func applicationWillTerminate(
        _ aNotification: Notification
    ) {
        // Insert code here to tear down your application
        
        AppDelegate.statusBarController.stopTimer()
    }
    
    func applicationSupportsSecureRestorableState(
        _ app: NSApplication
    ) -> Bool {
        return true
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
    
    @objc func toggleCollapse(
        _ sender: NSButton
    ) {
        if AppDelegate.statusBarController.collapsed {
            AppDelegate.statusBarController.disableCollapse()
        } else {
            AppDelegate.statusBarController.enableCollapse()
        }
    }
    
    func showPopover(
        _ sender: Any?
    ) {
        if let button = sender as? NSButton {
            popover.show(
                relativeTo: button.bounds,
                of: button,
                preferredEdge: NSRectEdge.minY
            )
        }
        
        eventMonitor?.start()
    }
    
    func closePopover(
        _ sender: Any?
    ) {
        popover.performClose(
            sender
        )
        
        eventMonitor?.stop()
    }
    
}
