//
//  StateManager.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/18.
//

import AppKit

extension StatusBarController {
    
    // MARK: - Icon Visibilities
    
    func untilHeadVisible(
        _ flag: Bool
    ) {
        untilSeparatorVisible(flag)
        head.isVisible = flag
    }
    
    func untilSeparatorVisible(
        _ flag: Bool
    ) {
        untilTailVisible(flag)
        body.isVisible = flag
    }
    
    func untilTailVisible(
        _ flag: Bool
    ) {
        tail.isVisible = flag
    }
    
}

extension StatusBarController {
    
    // MARK: - Enables
    
    func collapse() {
        unidleHideArea()
        Data.collapsed = true
    }
    
    func idleHideArea() {
        idling.hide = true
    }
    
    func idleAlwaysHideArea() {
        idling.alwaysHide = true
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
                
                guard strongSelf.feedbackCount < Data.feedbackAttribute.feedback.count else {
                    strongSelf.feedbackCount = 0
                    strongSelf.stopTimer(&strongSelf.feedbackTimer)
                    
                    return
                }
                
                if let pattern = Data.feedbackAttribute.feedback[strongSelf.feedbackCount] {
                    NSHapticFeedbackManager.defaultPerformer.perform(pattern, performanceTime: .now)
                }
                
                strongSelf.feedbackCount += 1
            }
        }
    }
    
    func startTriggerTimer() {
        if triggerTimer == nil {
            triggerTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 6.0,
                repeats: true
            ) { [weak self] _ in
                guard let strongSelf = self
                else { return }
                
                strongSelf.checkIdleStates()
                
                if strongSelf.shouldEdgeUpdate.will {
                    strongSelf.shouldEdgeUpdate.now = true
                }
                
                if strongSelf.shouldEdgeUpdate.now {
                    strongSelf.updateEdge()
                }
                
                if !strongSelf.shouldEdgeUpdate.will {
                    strongSelf.shouldEdgeUpdate.now = false
                }
                
                let mouseNeedsUpdate = strongSelf.was.mouseSpare != strongSelf.mouseSpare
                let keyNeedsUpdate = strongSelf.was.modifiers != Helper.Keyboard.modifiers
                
                if mouseNeedsUpdate {
                    if strongSelf.was.mouseSpare {
                        strongSelf.stopMonitor(&strongSelf.mouseEventMonitor)
                    } else {
                        strongSelf.startMouseEventMonitor()
                    }
                }
                
                if mouseNeedsUpdate || keyNeedsUpdate {
                    strongSelf.startFunctionalTimers()
                }
                
                if keyNeedsUpdate {
                    strongSelf.sort()
                    strongSelf.map()
                }
                
                strongSelf.was = (
                    mouseSpare: strongSelf.mouseSpare,
                    modifiers: Helper.Keyboard.modifiers
                )
            }
        }
    }
    
    func startTimeoutTimer() {
        let timeoutAttribute = Data.timeoutAttribute
        
        if timeoutTimer == nil && timeoutAttribute.attr != nil {
            timeoutTimer = Timer.scheduledTimer(
                withTimeInterval: Double(timeoutAttribute.attr!),
                repeats: false
            ) { [weak self] _ in
                guard let strongSelf = self else { return }
                
                strongSelf.unidleHideArea()
                strongSelf.stopTimer(&strongSelf.timeoutTimer) { strongSelf.timeout = true }
            }
        }
    }
    
    func startIgnoringTimer() {
        if ignoringTimer == nil && ignoring {
            ignoringTimer = Timer.scheduledTimer(
                withTimeInterval: 1,
                repeats: false
            ) { [weak self] _ in
                guard let strongSelf = self else { return }
                
                strongSelf.stopTimer(&strongSelf.ignoringTimer) { strongSelf.ignoring = false }
            }
        }
    }
    
    func startFunctionalTimers() {
        startAnimationTimer()
        startActionTimer()
        
        shouldEdgeUpdate.will = false
        timeout = false
        
        if (idling.hide || idling.alwaysHide) {
            startTimeoutTimer()
        }
        
        if (!idling.hide && !idling.alwaysHide) {
            stopTimer(&timeoutTimer) { timeout = true }
        }
    }
    
    func startMouseEventMonitor() {
        if mouseEventMonitor == nil {
            mouseEventMonitor = EventMonitor(
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
            
            mouseEventMonitor?.start()
        }
    }
    
    // MARK: - Disables
    
    func uncollapse() {
        Data.collapsed = false
        unidleHideArea()
    }
    
    func unidleHideArea() {
        idling.hide = false
        unidleAlwaysHideArea()
    }
    
    func unidleAlwaysHideArea() {
        idling.alwaysHide = false
        startFunctionalTimers()
    }
    
    func stopTimer(_ timer: inout Timer?, afterStopped: () -> Void = {}) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
            
            afterStopped()
        }
    }
    
    func stopMonitor(_ monitor: inout EventMonitor?, afterStopped: () -> Void = {}) {
        if monitor != nil {
            monitor?.stop()
            monitor = nil
            
            afterStopped()
        }
    }
    
    func stopFunctionalTimers() {
        stopTimer(&animationTimer)
        stopTimer(&actionTimer)
        
        shouldEdgeUpdate.will = true
        timeout = false
    }
    
}
