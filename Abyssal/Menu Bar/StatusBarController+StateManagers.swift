//
//  StateManager.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/18.
//

import AppKit
import Defaults

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
    func toggle() {
        if Defaults[.isActive] {
            deactivate()
        } else {
            activate()
        }
    }
    
    // MARK: - Enables
    
    func activate() {
        unidleHideArea()
        Defaults[.isActive] = true
    }
    
    func idleHideArea() {
        idling.hide = true
    }
    
    func idleAlwaysHideArea() {
        idling.alwaysHide = true
    }
    
    func startAnimationTimer() {
        if animationTimer == nil {
            animationTimer = .scheduledTimer(
                withTimeInterval: 1.0 / 60.0,
                repeats: true
            ) { [weak self] _ in
                guard let self else { return }
                
                self.update()
            }
            print("START TIMER [ANIMATION]: \(animationTimer!)")
        }
    }
    
    func startActionTimer() {
        if actionTimer == nil {
            actionTimer = .scheduledTimer(
                withTimeInterval: 1.0 / 6.0,
                repeats: true
            ) { [weak self] _ in
                guard let self else { return }
                
                self.sort()
                self.map()
            }
            print("START TIMER [ACTION]: \(actionTimer!)")
        }
    }
    
    func startFeedbackTimer() {
        if feedbackTimer == nil && shouldPresentFeedback {
            feedbackTimer = .scheduledTimer(
                withTimeInterval: 1.0 / 30.0,
                repeats: true
            ) { [weak self] _ in
                guard let self else { return }
                
                guard self.feedbackCount < Defaults[.feedback].pattern.count else {
                    self.feedbackCount = 0
                    self.stopTimer(&self.feedbackTimer)
                    
                    return
                }
                
                if let pattern = Defaults[.feedback].pattern[self.feedbackCount] {
                    NSHapticFeedbackManager.defaultPerformer.perform(pattern, performanceTime: .default)
                }
                
                self.feedbackCount += 1
            }
            print("START TIMER [FEEDBACK]: \(feedbackTimer!)")
        }
    }
    
    func startTriggerTimer() {
        if triggerTimer == nil {
            triggerTimer = .scheduledTimer(
                withTimeInterval: 1.0 / 6.0,
                repeats: true
            ) { [weak self] _ in
                guard let self else { return }
                
                // Check idle states
                checkIdleStates()
                
                // Update dragging state
                if draggedToDeactivate.dragging && !mouseDragging.value() {
                    draggedToDeactivate.dragging = false
                    noAnimation = false
                    
                    unidleAlwaysHideArea()
                    startAnimationTimer()
                }
                
                else if mouseDragging.value() && !draggedToDeactivate.dragging {
                    if draggedToDeactivate.count < 3 {
                        draggedToDeactivate.count += 1
                    } else {
                        draggedToDeactivate.dragging = true
                        draggedToDeactivate.count = 0
                        
                        noAnimation = true
                        idleAlwaysHideArea()
                        startAnimationTimer()
                    }
                }
                
                // Update edge
                if shouldEdgeUpdate.will {
                    shouldEdgeUpdate.now = true
                } else {
                    shouldEdgeUpdate.now = false
                }
                
                if shouldEdgeUpdate.now {
                    updateEdge()
                }
                
                // Update mouse and keys
                if !MouseManager.dragging {
                    if mouseOnStatusBar.needsUpdate || mouseSpare.needsUpdate {
                        if mouseOnStatusBar.value() || mouseSpare.value() {
                            startMouseEventMonitor()
                        } else {
                            stopMonitor(&mouseEventMonitor)
                        }
                    }
                    
                    if mouseOnStatusBar.needsUpdate || mouseSpare.needsUpdate || keyboardTriggers.needsUpdate {
                        // Resolve animation and function updates
                        startFunctionalTimers()
                    }
                }
                
                if keyboardTriggers.needsUpdate || self.mouseDragging.value() {
                    // Key pressed || mouse dragging -> sort separators and map appearances
                    sort()
                    map()
                }
                
                // Update frontmost app
                if focusedApp.needsUpdate {
                    if Defaults[.screenSettings].main.activeStrategy.frontmostAppChange {
                        // When frontmost app changes
                        unidleHideArea()
                    }
                }
                
                // Update main screen
                if mainScreen.needsUpdate {
                    if Defaults[.screenSettings].main.activeStrategy.screenChange {
                        // When main screen changes
                        unidleHideArea()
                    }
                }
                
                // Update external menu states
                if hasExternalMenus.value() {
                    // Automatically update after once cached
                    updateExternalMenus()
                }
                
                if hasExternalMenus.needsUpdate {
                    if hasExternalMenus.value() {
                        // Will keep inactivated
                        print("Has external menu")
                    } else {
                        // Will be normal
                        print("No longer has external menu")
                    }
                }
                
                
                
                // Update blocking status
                if blocking.needsUpdate {
                    if blocking.value() {
                        // Blocked
                    } else {
                        // Released
                        startTimeoutTimer()
                    }
                }
                
                
                
                // Update intermediate states
                mouseOnStatusBar.update()
                mouseInHideArea.update()
                mouseInAlwaysHideArea.update()
                mouseSpare.update()
                
                mouseOverHead.update()
                mouseOverBody.update()
                mouseOverTail.update()
                
                mouseDragging.update()
                
                hasExternalMenus.update()
                keyboardTriggers.update()
                focusedApp.update()
                mainScreen.update()
                    
                blocking.update()
            }
            print("START TIMER [TRIGGER]: \(triggerTimer!)")
        }
    }
    
    func startTimeoutTimer() {
        let timeout = Defaults[.timeout]
        
        if timeoutTimer == nil && timeout.attribute != nil {
            timeoutTimer = .scheduledTimer(
                withTimeInterval: Double(timeout.attribute!),
                repeats: false
            ) { [weak self] _ in
                guard let self else { return }
                
                unidleHideArea()
                stopTimer(&timeoutTimer) { self.timeout = true }
            }
            print("START TIMER [TIMEOUT]: \(timeoutTimer!)")
        }
    }
    
    func startIgnoringTimer() {
        if ignoringTimer == nil && ignoring {
            ignoringTimer = .scheduledTimer(
                withTimeInterval: 1,
                repeats: false
            ) { [weak self] _ in
                guard let self else { return }
                
                stopTimer(&ignoringTimer) { self.ignoring = false }
            }
            print("START TIMER [IGNORING]: \(ignoringTimer!)")
        }
    }
    
    func startFunctionalTimers() {
        guard !MouseManager.dragging else { return }
        startAnimationTimer()
        startActionTimer()
        
        shouldEdgeUpdate.will = false
        timeout = false
        
        if idlingAny {
            startTimeoutTimer()
        }
        
        if idlingNone {
            stopTimer(&timeoutTimer) { timeout = true }
        }
    }
    
    func startMouseEventMonitor() {
        if mouseEventMonitor == nil {
            mouseEventMonitor = EventMonitor(
                mask: [.leftMouseDown,
                       .rightMouseDown,]
            ) { [weak self] event in
                guard
                    let self,
                    self.mouseSpare.value()
                else { return }
                
                // Update idling status
                if
                    self.isActive
                        && self.mouseInHideArea.value()
                        && !(KeyboardManager.command && event?.type == .leftMouseDown)
                {
                    self.idleHideArea()
                }
                
                if self.mouseInAlwaysHideArea.value() {
                    self.idleAlwaysHideArea()
                }
                
                // Update external menu caches
                ExternalMenuBarManager.menuBarItems.forEach { $0.cache() }
                self.externalMenus.removeAll()
                
                self.updateExternalMenusDispatch?.cancel()
                self.updateExternalMenusDispatch = .init {
                    self.updateExternalMenus()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: self.updateExternalMenusDispatch!)
            }
            
            mouseEventMonitor?.start()
            print("START MONITOR [MOUSE EVENT]: \(mouseEventMonitor!)")
        }
    }
    
    // MARK: - Disables
    
    func deactivate() {
        Defaults[.isActive] = false
        unidleHideArea()
    }
    
    func unidleHideArea() {
        guard !blocking.value() else { return }
        idling.hide = false
        unidleAlwaysHideArea()
    }
    
    func unidleAlwaysHideArea() {
        guard !blocking.value() else { return }
        idling.alwaysHide = false
        startFunctionalTimers()
    }
    
    func stopTimer(_ timer: inout Timer?, afterStopped: () -> Void = {}) {
        if timer != nil {
            print("STOP TIMER: \(timer!)")
            timer?.invalidate()
            timer = nil
            
            afterStopped()
        }
    }
    
    func stopMonitor(_ monitor: inout EventMonitor?, afterStopped: () -> Void = {}) {
        if monitor != nil {
            print("STOP MONITOR: \(monitor!)")
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
