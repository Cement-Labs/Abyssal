//
//  AppDelegate.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(
        withLength:NSStatusItem.variableLength
    )
    
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?
    
    
    func applicationDidFinishLaunching(
        _ aNotification: Notification
    ) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(togglePopover(_:))
        }
        
        popover.contentViewController = ViewController.freshController()
        
        eventMonitor = EventMonitor(
            mask: [.leftMouseDown,
                   .rightMouseDown]
        ) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
    
    
    func applicationWillTerminate(
        _ aNotification: Notification
    ) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(
        _ app: NSApplication
    ) -> Bool {
        return true
    }
    
    @objc func togglePopover(
        _ sender: Any?
    ) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(
        sender: Any?
    ) {
        if let button = statusItem.button {
            popover.show(
                relativeTo: button.bounds,
                of: button,
                preferredEdge: NSRectEdge.minY
            )
        }
        
        eventMonitor?.start()
    }
    
    func closePopover(
        sender: Any?
    ) {
        popover.performClose(
            sender
        )
        
        eventMonitor?.stop()
    }
    
}
