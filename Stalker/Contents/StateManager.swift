//
//  StatusBarStateManager.swift
//  Stalker
//
//  Created by KrLite on 2023/6/18.
//

import AppKit

// Timers

var animationTimer: Timer?

var actionTimer: Timer?

var triggerTimer: Timer?

// Event monitors

var mouseClickEventMonitor: EventMonitor?

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

var mouseWasSpare: Bool = false

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
	
    func startAnimationTimer() {
        if animationTimer == nil {
            animationTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 30.0,
                repeats: true
            ) { [weak self] _ in
                guard let strongSelf = self else { return }
                
                strongSelf.update()
            }
        }
	}
    
    func startActionTimer() {
        if actionTimer == nil {
            actionTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 6.0,
                repeats: true
            ) { [weak self] _ in
                guard let strongSelf = self else { return }
                
                strongSelf.sort()
                strongSelf.map()
            }
        }
    }
    
    func startTriggerTimer() {
        if triggerTimer == nil {
            triggerTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 6.0,
                repeats: true
            ) { [weak self] _ in
                guard let strongSelf = self else { return }
                
                strongSelf.checkIdleStates()
                
                if !mouseWasSpare && strongSelf.mouseSpare {
                    strongSelf.startMouseClickEventMonitor()
                } else if mouseWasSpare && !strongSelf.mouseSpare {
                    strongSelf.stopMouseClickEventMonitor()
                }
                
                if strongSelf.shouldTimersStop {
                    strongSelf.shouldTimersStop = false
                    strongSelf.stopFunctionalTimers()
                }
                
                if Data.collapsed && (mouseWasSpare != strongSelf.mouseSpare || (strongSelf.mouseSpare && (Helper.Keyboard.command || Helper.Keyboard.option))) {
                    strongSelf.startFunctionalTimers()
                }
                
                if strongSelf.mouseSpare && (Helper.Keyboard.command || Helper.Keyboard.option) && Helper.Mouse.left {
                    strongSelf.sort()
                    strongSelf.map()
                }
                
                mouseWasSpare = strongSelf.mouseSpare
            }
        }
    }
    
    func startFunctionalTimers() {
        startAnimationTimer()
        startActionTimer()
    }
	
    func startMouseClickEventMonitor() {
        if mouseClickEventMonitor == nil {
            mouseClickEventMonitor = EventMonitor(
                mask: [.leftMouseDown,
                       .rightMouseDown]
            ) { [weak self] event in
                guard
                    let strongSelf = self,
                    strongSelf.mouseSpare
                else { return }
                
                if Data.collapsed && strongSelf.mouseInHideArea && !(Helper.Keyboard.command && event?.type == .leftMouseDown) {
                    strongSelf.idleHideArea()
                }
                
                if strongSelf.mouseInAlwaysHideArea {
                    strongSelf.idleAlwaysHideArea()
                }
            }
            
            mouseClickEventMonitor?.start()
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
        startFunctionalTimers()
	}
    
    func stopAnimationTimer() {
        if animationTimer != nil {
            animationTimer?.invalidate()
            animationTimer = nil
        }
    }
    
    func stopActionTimer() {
        if actionTimer != nil {
            actionTimer?.invalidate()
            actionTimer = nil
        }
    }
    
    func stopTriggerTimer() {
        if triggerTimer != nil {
            triggerTimer?.invalidate()
            triggerTimer = nil
        }
    }
    
    func stopFunctionalTimers() {
        stopAnimationTimer()
        stopActionTimer()
    }
	
    func stopMouseClickEventMonitor() {
        if mouseClickEventMonitor != nil {
            mouseClickEventMonitor?.stop()
            mouseClickEventMonitor = nil
        }
	}
	
}
