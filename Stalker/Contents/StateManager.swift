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
		self.idling = true
	}
	
	func idleAlwaysHideArea() {
		self.idlingAlwaysHideArea = true
	}
	
	func startTimers() {
		animationTimer = Timer.scheduledTimer(
			withTimeInterval: 1.0 / 60.0,
			repeats: true
		) { [weak self] _ in
			if let strongSelf = self {
				strongSelf.update()
			}
		}
		
		actionTimer = Timer.scheduledTimer(
			withTimeInterval: 1.0 / 10.0,
			repeats: true
		) { [weak self] _ in
			if let strongSelf = self {
				strongSelf.reorder()
				strongSelf.remap()
			}
		}
	}
	
	func startMonitors() {
		mouseEventMonitor = EventMonitor(
			mask: [.leftMouseDown,
				   .rightMouseDown]
		) { [weak self] event in
			
			guard
				let strongSelf = self,
				let inside = strongSelf.inside,
				strongSelf.mouseOnStatusBar
			else { return }
			
			if Data.collapsed && inside.containsMouse && !(Helper.Keyboard.command && event?.type == .leftMouseDown) {
				strongSelf.idle()
			}
			
			if strongSelf.mouseOverAlwaysHideArea {
				strongSelf.idleAlwaysHideArea()
			}
		}
		
		mouseEventMonitor?.start()
	}
	
	// MARK: - Disables
	
	func uncollapse() {
		Data.collapsed = false
		unidleHideArea()
	}
	
	func unidleHideArea() {
		self.idling = false
		unidleAlwaysHideArea()
	}
	
	func unidleAlwaysHideArea() {
		self.idlingAlwaysHideArea = false
	}
	
	func stopTimers() {
		animationTimer?	.invalidate()
		actionTimer?	.invalidate()
		
		animationTimer 	= nil
		actionTimer 	= nil
	}
	
	func stopMonitors() {
		mouseEventMonitor?.stop()
	}
	
}
