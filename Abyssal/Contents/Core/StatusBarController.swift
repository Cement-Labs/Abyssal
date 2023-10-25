//
//  StatusBarController.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
    
    // MARK: - States
    
    var edge = CGFloat.zero
    
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
    
    var mouseDragging: Bool {
        Helper.Mouse.dragging && mouseOnStatusBar
    }
    
    
    
    var timeout = false

    var shouldEdgeUpdate = (now: false, will: false)

    var shouldPresentFeedback: Bool {
        return !timeout && Helper.Mouse.none
    }
    
    var feedbackCount = Int.zero

    var was = (mouseSpare: false, modifiers: false)
    
    
    // MARK: - Animations

    var mouseWasSpareOrUnidled = false

    var shouldTimersStop = (flag: false, count: Int.zero)
    
    var draggedToUncollapse = (dragging: false, shouldCollapse: false, shouldEnableAnimation: false, count: Int(0))

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
    
    private static let _sep0 = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.variableLength
    )
    
    private static let _sep1 = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.variableLength
    )
    
    private static let _sep2 = NSStatusBar.system.statusItem(
        withLength: NSStatusItem.variableLength
    )
    
    // Separators list
    
    private static var _seps = [_sep0, _sep1, _sep2]
    
    // Pointers specifying the separators' positions
    
    var head = Separator(order: 2) { StatusBarController._seps }
    
    var body = Separator(order: 1) { StatusBarController._seps }
    
    var tail = Separator(order: 0) { StatusBarController._seps }
    
    // MARK: - Inits
    
    init() {
        // Init separators
        
        // By default, _sep0 is the most left while _sep2 is the most right.
        // However this will change to conserve the relative position of the separators.
        sort()
        
        if let button = StatusBarController._sep0.button {
            button.action = #selector(AppDelegate.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        if let button = StatusBarController._sep1.button {
            button.action = #selector(AppDelegate.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        if let button = StatusBarController._sep2.button {
            button.action = #selector(AppDelegate.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Start services
        
        startAnimationTimer()
        startActionTimer()
        
        startTriggerTimer()
        
        draggedToUncollapse.shouldCollapse = Data.collapsed
        draggedToUncollapse.shouldEnableAnimation = !Data.reduceAnimation
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
        // Make sure the rightmost separator is positioned further back in the array
        StatusBarController._seps.sort { (first, second) in
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
