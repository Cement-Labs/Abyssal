//
//  StatusBarController.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import AppKit
import Defaults

// status items

let statusItem0 = NSStatusBar.system.statusItem(
    withLength: NSStatusItem.variableLength
)

let statusItem1 = NSStatusBar.system.statusItem(
    withLength: NSStatusItem.variableLength
)

let statusItem2 = NSStatusBar.system.statusItem(
    withLength: NSStatusItem.variableLength
)

var statusItems = [statusItem0, statusItem1, statusItem2]

class StatusBarController {
    // MARK: - Lazy States

    lazy var mouseOnStatusBar: WithIntermediateState<Bool> = .init {
        guard
            let headOrigin = self.head.button?.window?.frame.origin,
            let headSize = self.head.button?.window?.frame.size
        else { return false }
        let mouseLocation = NSEvent.mouseLocation
        return mouseLocation.x >= ScreenManager.menuBarLeftEdge
        && mouseLocation.y >= headOrigin.y
        && mouseLocation.y <= headOrigin.y + headSize.height
    }

    lazy var mouseInHiddenArea: WithIntermediateState<Bool> = .init {
        guard
            let bodyOrigin = self.body.button?.window?.frame.origin,
            let tailOrigin = self.tail.button?.window?.frame.origin,
            let tailSize = self.tail.button?.window?.frame.size
        else { return false }
        return self.mouseOnStatusBar.value()
        && NSEvent.mouseLocation.x >= tailOrigin.x + tailSize.width
        && NSEvent.mouseLocation.x <= bodyOrigin.x
    }

    lazy var mouseInAlwaysHiddenArea: WithIntermediateState<Bool> = .init {
        guard let origin = self.tail.button?.window?.frame.origin else { return false }
        return self.mouseOnStatusBar.value() && NSEvent.mouseLocation.x <= origin.x
    }

    lazy var mouseSpare: WithIntermediateState<Bool> = .init {
        !self.ignoring
        && self.mouseOnStatusBar.value()
        && NSEvent.mouseLocation.x <= self.edge
    }

    lazy var mouseOverHead: WithIntermediateState<Bool> = .init {
        guard
            let origin = self.head.button?.window?.frame.origin,
            let width = self.head.button?.window?.frame.width
        else { return false }
        return self.mouseOnStatusBar.value()
        && NSEvent.mouseLocation.x >= origin.x
        && NSEvent.mouseLocation.x <= origin.x + width
    }

    lazy var mouseOverBody: WithIntermediateState<Bool> = .init {
        guard
            let origin = self.body.button?.window?.frame.origin,
            let width = self.body.button?.window?.frame.width
        else { return false }
        return self.mouseOnStatusBar.value()
        && NSEvent.mouseLocation.x >= origin.x
        && NSEvent.mouseLocation.x <= origin.x + width
    }

    lazy var mouseOverTail: WithIntermediateState<Bool> = .init {
        guard
            let origin = self.tail.button?.window?.frame.origin,
            let width = self.tail.button?.window?.frame.width
        else { return false }
        return self.mouseOnStatusBar.value()
        && NSEvent.mouseLocation.x >= origin.x
        && NSEvent.mouseLocation.x <= origin.x + width
    }

    lazy var mouseDragging: WithIntermediateState<Bool> = .init {
        MouseModel.shared.dragging && self.mouseOnStatusBar.value()
    }

    lazy var hasExternalMenus: WithIntermediateState<Bool> = .init {
        !self.externalMenus.isEmpty
    }

    lazy var keyboardTriggers: WithIntermediateState<Bool> = .init {
        KeyboardModel.shared.triggers
    }

    lazy var focusedApp: WithIntermediateState<NSRunningApplication> = .init {
        AppManager.frontmost
    }

    lazy var mainScreen: WithIntermediateState<NSScreen?> = .init {
        ScreenManager.main
    }

    lazy var blocking: WithIntermediateState<Bool> = .init {
        self.hasExternalMenus.value()
    }

    // MARK: - Variable States

    var shouldPresentFeedback: Bool {
        !timeout && MouseModel.shared.none
    }

    var maxLength: CGFloat {
        ScreenManager.maxWidth
    }

    var isActive: Bool {
        AbyssalApp.isActive
    }

    var edge = CGFloat.zero

    var shouldEdgeUpdate = (now: false, will: false)

    var idling = (hidden: false, alwaysHidden: false)

    var noAnimation = false

    var ignoring = false

    var timeout = false

    var externalMenus: [WindowInfo] = []

    var feedbackCount = Int.zero

    var shouldTimersStop = (flag: false, count: Int.zero)

    var mouseWasSpareOrUnidled = false

    var draggedToDeactivate = (dragging: false, count: Int.zero)

    // MARK: - Timers & Event Monitors

    var animationTimer: Timer?

    var actionTimer: Timer?

    var feedbackTimer: Timer?

    var triggerTimer: Timer?

    var timeoutTimer: Timer?

    var ignoringTimer: Timer?

    var mouseEventMonitor: EventMonitor?

    // MARK: - Separators

    var head = Separator(order: 2) { statusItems }

    var body = Separator(order: 1) { statusItems }

    var tail = Separator(order: 0) { statusItems }

    // MARK: - Inits

    init() {
        // init separators

        // by default, _item0 is the most left while _item2 is the most right
        // however this will change to conserve the relative position of the separators
        sort()

        if let button = statusItem0.button {
            button.action = #selector(AbyssalApp.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        if let button = statusItem1.button {
            button.action = #selector(AbyssalApp.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        if let button = statusItem2.button {
            button.action = #selector(AbyssalApp.toggle(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        // start services

        startAnimationTimer()
        startActionTimer()

        startTriggerTimer()
    }

    deinit {
        // stop services

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
        // make sure the rightmost separator is positioned further back in the array
        statusItems.sort { (first, second) in
            if !first.isVisible {
                // the first one is invisible -> the first one is more lefty
                return true
            } else if !second.isVisible {
                // the first one is visible while the second one is invisible -> the second one is more lefty
                return false
            } else if let x1 = first.origin?.x, let x2 = second.origin?.x {
                // both have reasonable x positions -> the leftmost one is more lefty
                return x1 <= x2
            } else { return true }
        }
    }

    func updateEdge() {
        edge = (body.origin?.x ?? 0) + body.length
    }

    func updateExternalMenus() {
        externalMenus = ExternalMenuBarManager.menuBarItems.flatMap {
            $0.newWindowsNear
        }
    }
}
