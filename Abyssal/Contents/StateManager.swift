//
//  StatusBarStateManager.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/18.
//

import AppKit

// Timers

var animationTimer: Timer?

var actionTimer: Timer?

var feedbackTimer: Timer?

var triggerTimer: Timer?

var timeoutTimer: Timer?

// Event monitors

var mouseClickEventMonitor: EventMonitor?



var timeout: Bool = false

var shouldEdgeUpdate: (now: Bool, will: Bool) = (now: false, will: false)

var shouldPresentFeedback: Bool {
    return !timeout && Helper.Mouse.none
}

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

var feedbackCount: Int = 0

var was: (mouseSpare: Bool, command: Bool) = (mouseSpare: false, command: false)

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
    
    func startFeedbackTimer() {
        if feedbackTimer == nil && shouldPresentFeedback {
            feedbackTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 30.0,
                repeats: true
            ) { [weak self] _ in
                guard let strongSelf = self else { return }
                
                guard feedbackCount < Data.feedbackAttributes.count else {
                    feedbackCount = 0
                    strongSelf.stopFeedbackTimer()
                    
                    return
                }
                
                if let pattern = Data.feedbackAttributes[feedbackCount] {
                    NSHapticFeedbackManager.defaultPerformer.perform(pattern, performanceTime: .now)
                }
                
                feedbackCount += 1
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
                
                if shouldEdgeUpdate.will {
                    shouldEdgeUpdate.now = true
                }
                
                if shouldEdgeUpdate.now {
                    strongSelf.updateEdge()
                }
                
                if !shouldEdgeUpdate.will {
                    shouldEdgeUpdate.now = false
                }
                
                let mouseNeedsUpdate = was.mouseSpare != strongSelf.mouseSpare
                let keyNeedsUpdate = strongSelf.mouseSpare && (was.command != Helper.Keyboard.command)
                
                if mouseNeedsUpdate {
                    if was.mouseSpare {
                        strongSelf.stopMouseClickEventMonitor()
                    } else {
                        strongSelf.startMouseClickEventMonitor()
                    }
                }
                
                if mouseNeedsUpdate || keyNeedsUpdate {
                    strongSelf.startFunctionalTimers()
                }
                
                if keyNeedsUpdate && Helper.Mouse.left {
                    strongSelf.sort()
                    strongSelf.map()
                }
                
                was.mouseSpare = strongSelf.mouseSpare
                was.command = Helper.Keyboard.command
            }
        }
    }
    
    func startTimeoutTimer() {
        if timeoutTimer == nil {
            timeoutTimer = Timer.scheduledTimer(
                withTimeInterval: 30.0,
                repeats: false,
                block: { [weak self] _ in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.unidleHideArea()
                    strongSelf.stopTimeoutTimer()
                }
            )
        }
    }
    
    func startFunctionalTimers() {
        // print("START")
        startAnimationTimer()
        startActionTimer()
        
        shouldEdgeUpdate.will = false
        timeout = false
        
        if (idling.hide || idling.alwaysHide) {
            startTimeoutTimer()
        }
        
        if (!idling.hide && !idling.alwaysHide) {
            stopTimeoutTimer()
        }
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
    
    func stopFeedbackTimer() {
        if feedbackTimer != nil {
            feedbackTimer?.invalidate()
            feedbackTimer = nil
        }
    }
    
    func stopTriggerTimer() {
        if triggerTimer != nil {
            triggerTimer?.invalidate()
            triggerTimer = nil
        }
    }
    
    func stopTimeoutTimer() {
        if timeoutTimer != nil {
            timeoutTimer?.invalidate()
            timeoutTimer = nil
            
            timeout = true
        }
    }
    
    func stopFunctionalTimers() {
        // print("SHUT")
        stopAnimationTimer()
        stopActionTimer()
        
        shouldEdgeUpdate.will = true
        timeout = false
    }
    
    func stopMouseClickEventMonitor() {
        if mouseClickEventMonitor != nil {
            mouseClickEventMonitor?.stop()
            mouseClickEventMonitor = nil
        }
    }
    
}
