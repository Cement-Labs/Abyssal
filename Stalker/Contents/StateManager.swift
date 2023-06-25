//
//  StatusBarStateManager.swift
//  Stalker
//
//  Created by KrLite on 2023/6/18.
//

import AppKit

// Timers

var animationTimer: Timer?

var actionTimer:     Timer?

// Event monitors

var mouseEventMonitor: EventMonitor?

extension StatusBarController {
	
	// MARK: - Icon Visibilities
	
	func untilHeadVisible(
		_ flag: Bool
	) {
		untilSeparatorVisible(flag)
		self.head.isVisible = flag
	}
	
	func untilSeparatorVisible(
		_ flag: Bool
	) {
		untilTailVisible(flag)
		self.body.isVisible = flag
	}
	
	func untilTailVisible(
		_ flag: Bool
	) {
		self.tail.isVisible = flag
	}
	
}

extension StatusBarController {
	
	// MARK: - Enables
	
	func collapse() {
		unidleHideArea()
		Data.collapsed = true
	}
	
	func idleHideArea() {
		self.idling.hide = true
	}
	
    func idleAlwaysHideArea() {
		self.idling.alwaysHide = true
	}
	
    func startTimers() {
		animationTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0 / 24.0,
			repeats: true
		) { [weak self] _ in
			if let strongSelf = self {
				strongSelf.update()
			}
		}
		
		actionTimer = Timer.scheduledTimer(
			withTimeInterval: 1.0 / 6.0,
			repeats: true
		) { [weak self] _ in
			if let strongSelf = self {
				strongSelf.sort()
				strongSelf.map()
			}
		}
	}
	
	func startMonitors() {
        if mouseEventMonitor == nil {
            mouseEventMonitor = EventMonitor(
                mask: [.leftMouseDown,
                       .rightMouseDown]
            ) { [weak self] event in
                
                guard
                    let strongSelf = self,
                    strongSelf.mouseOnStatusBar
                else { return }
                
                if Data.collapsed && strongSelf.mouseInHideArea && !(Helper.Keyboard.command && event?.type == .leftMouseDown) {
                    strongSelf.idleHideArea()
                }
                
                if strongSelf.mouseInAlwaysHideArea {
                    strongSelf.idleAlwaysHideArea()
                }
            }
            
            mouseEventMonitor?.start()
        }
	}
	
	// MARK: - Disables
	
	func uncollapse() {
		Data.collapsed = false
		unidleHideArea()
	}
	
	func unidleHideArea() {
		self.idling.hide = false
		unidleAlwaysHideArea()
	}
	
	func unidleAlwaysHideArea() {
		self.idling.alwaysHide = false
	}
	
	func stopTimers() {
        if animationTimer != nil {
            animationTimer?.invalidate()
            animationTimer = nil
        }
        
        if actionTimer != nil {
            actionTimer?.invalidate()
            actionTimer = nil
        }
	}
	
	func stopMonitors() {
		mouseEventMonitor?.stop()
	}
	
}
