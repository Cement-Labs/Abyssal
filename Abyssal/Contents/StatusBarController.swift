//
//  StatusBarController.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
    
    // MARK: - States
    
    var available = false
    
    var edge = 0.0
    
    var alphaValues = (h: 0.0, b: 0.0, t: 0.0)
    
    var lengths = (h: 0.0, b: 0.0, t: 0.0)
    
    var idling = (hide: false, alwaysHide: false)
    
    var ignoring = false
    
    
    
    var mouseOnStatusBar: Bool {
        guard let origin = head.button?.window?.frame.origin else { return false }
        return NSEvent.mouseLocation.x >= Helper.menuBarLeftEdge && NSEvent.mouseLocation.y >= origin.y
    }
    
    var mouseInHideArea: Bool {
        guard
            let bodyOrigin = body.button?.window?.frame.origin,
            let tailOrigin = tail.button?.window?.frame.origin,
            let tailWidth = tail.button?.window?.frame.width
        else { return false }
        return mouseOnStatusBar && NSEvent.mouseLocation.x >= tailOrigin.x + tailWidth && NSEvent.mouseLocation.x <= bodyOrigin.x
    }
    
    var mouseInAlwaysHideArea: Bool {
        guard let origin = tail.button?.window?.frame.origin else { return false }
        return mouseOnStatusBar && NSEvent.mouseLocation.x <= origin.x
    }
    
    var mouseSpare: Bool {
        return !ignoring && mouseOnStatusBar && NSEvent.mouseLocation.x <= edge
    }
    
    var mouseOverHead: Bool {
        guard
            let origin = head.button?.window?.frame.origin,
            let width = head.button?.window?.frame.width
        else { return false }
        return mouseOnStatusBar && NSEvent.mouseLocation.x >= origin.x && NSEvent.mouseLocation.x <= origin.x + width
    }
    
    var mouseOverBody: Bool {
        guard
            let origin = body.button?.window?.frame.origin,
            let width = body.button?.window?.frame.width
        else { return false }
        return mouseOnStatusBar && NSEvent.mouseLocation.x >= origin.x && NSEvent.mouseLocation.x <= origin.x + width
    }
    
    var mouseOverTail: Bool {
        guard
            let origin = tail.button?.window?.frame.origin,
            let width = tail.button?.window?.frame.width
        else { return false }
        return mouseOnStatusBar && NSEvent.mouseLocation.x >= origin.x && NSEvent.mouseLocation.x <= origin.x + width
    }
    
    
    
    var timeout = false

    var shouldEdgeUpdate = (now: false, will: false)

    var shouldPresentFeedback: Bool {
        return !timeout && Helper.Mouse.none
    }
    
    var feedbackCount: Int = 0

    var was = (mouseSpare: false, modifiers: false)
    
    
    // MARK: - Animations
    
    var lastOriginXs = (b: 0.0, t: 0.0)

    var lastFlags = (b: false, t: false)

    var wasUnstable = (b: true, t: true)

    var mouseWasSpareOrUnidled = false

    

    var shouldTimersStop: (flag: Bool, count: Int) = (flag: false, count: 0)

    var maxLength: CGFloat {
        return Helper.Screen.maxWidth ?? 10000 // To cover all possible screens
    }

    var popoverShown: Bool {
        return Helper.delegate?.popover.isShown ?? false
    }
    
    
    
    // MARK: - Timers & Event Monitors

    var animationTimer: Timer?

    var actionTimer: Timer?

    var feedbackTimer: Timer?

    var triggerTimer: Timer?

    var timeoutTimer: Timer?
    
    var ignoringTimer: Timer?



    var mouseEventMonitor: EventMonitor?
    
    
    
    // MARK: - Icons
    
    // Separator instances
    
    private let _sep0: NSStatusItem = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.variableLength
    )
    
    private let _sep1: NSStatusItem = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.variableLength
    )
    
    private let _sep2: NSStatusItem = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.variableLength
    )
    
    // Separators list
    
    private var _seps: [NSStatusItem]
    
    // Pointers specifying the separators' positions
    
    var head: NSStatusItem {
        return _seps[2]
    }
    
    var body: NSStatusItem {
        return _seps[1]
    }
    
    var tail: NSStatusItem {
        return _seps[0]
    }
    
    // MARK: - Inits
    
    init() {
        // Init separators
        
        // By default, _sep0 is the most left while _sep2 is the most right.
        // However this will change to conserve the relative position of the separators.
        _seps = [_sep0, _sep1, _sep2]
        
        sort()
        
        head.length = lengths.h
        body.length = lengths.b
        tail.length = lengths.t
        
        if let button = self._sep0.button {
            button.action = #selector(AppDelegate.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        if let button = self._sep1.button {
            button.action = #selector(AppDelegate.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        if let button = self._sep2.button {
            button.action = #selector(AppDelegate.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Start services
        
        startAnimationTimer()
        startActionTimer()
        
        startTriggerTimer()
    }
    
    deinit {
        // Stop services
        
        stopTimer(&animationTimer)
        stopTimer(&actionTimer)
        
        stopTimer(&triggerTimer)
        
        stopTimer(&timeoutTimer)
        stopTimer(&ignoringTimer)
        
        stopMonitor(&mouseEventMonitor)
    }
    
}

extension StatusBarController {
    
    func sort() {
        guard available else {
            available = !(available && _seps.allSatisfy { sep in
                !sep.isVisible || sep.origin?.x ?? 0 != 0
            })
            return
        }
        
        // Make sure the rightmost separator is positioned further back in the array
        _seps.sort { (first, second) in
            if !first.isVisible {
                // The first one is invisible -> the first one is more lefty
                return true
            } else if !second.isVisible {
                // The first one is visible while the second one is invisible -> the second one is more lefty
                return false
            } else if let x1 = first.origin?.x, let x2 = second.origin?.x {
                // Both have reasonable x positions -> the leftmost one is more lefty
                return x1 <= x2
            } else { return true }
        }
    }
    
    func updateEdge() {
        edge = (body.button?.window?.frame.origin.x ?? 0) + (body.button?.window?.frame.width ?? 0) + (mouseSpare ? 4 : -8)
    }
    
}
