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
                self.checkIdleStates()
                
                // Update dragging state
                if self.draggedToDeactivate.dragging && !self.mouseDragging {
                    self.draggedToDeactivate.dragging = false
                    
                    if self.draggedToDeactivate.shouldActivate {
                        self.activate()
                    }
                    
                    self.noAnimation = false
                    
                    self.unidleAlwaysHideArea()
                    self.startAnimationTimer()
                }
                
                else if self.mouseDragging && !self.draggedToDeactivate.dragging {
                    if self.draggedToDeactivate.count < 3 {
                        self.draggedToDeactivate.count += 1
                    } else {
                        self.draggedToDeactivate.dragging = true
                        self.draggedToDeactivate.shouldActivate = self.isActive
                        self.draggedToDeactivate.count = 0
                        
                        if self.isActive {
                            self.draggedToDeactivate.shouldActivate = true
                            self.deactivate()
                        } else {
                            self.draggedToDeactivate.shouldActivate = false
                        }
                        
                        self.noAnimation = true
                        
                        self.idleAlwaysHideArea()
                        self.startAnimationTimer()
                    }
                }
                
                // Update edge
                if self.shouldEdgeUpdate.will {
                    self.shouldEdgeUpdate.now = true
                } else {
                    self.shouldEdgeUpdate.now = false
                }
                
                if self.shouldEdgeUpdate.now {
                    self.updateEdge()
                }
                
                // Update mouse and keys
                if !MouseManager.dragging {
                    if needsUpdate.mouseOnStatusBar || needsUpdate.mouseSpare {
                        if self.mouseOnStatusBar || self.mouseSpare {
                            self.startMouseEventMonitor()
                        } else {
                            self.stopMonitor(&self.mouseEventMonitor)
                        }
                    }
                    
                    if needsUpdate.mouseOnStatusBar || needsUpdate.mouseSpare || needsUpdate.triggers {
                        // Resolve animation and function updates
                        self.startFunctionalTimers()
                    }
                }
                
                if needsUpdate.triggers || self.mouseDragging {
                    // Key pressed || mouse dragging -> sort separators and map appearances
                    self.sort()
                    self.map()
                }
                
                // Update frontmost app
                if lastFocusedApp != AppManager.frontmost {
                    lastFocusedApp = AppManager.frontmost
                }
                
                // Update external menu states
                if self.was.mouseInExternalMenu != self.mouseInExternalMenu {
                    
                }
                
                self.was = (
                    self.mouseOnStatusBar,
                    self.mouseSpare,
                    KeyboardManager.triggers,
                    self.mouseInExternalMenu
                )
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
                
                self.unidleHideArea()
                self.stopTimer(&self.timeoutTimer) { self.timeout = true }
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
                
                self.stopTimer(&self.ignoringTimer) { self.ignoring = false }
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
                    self.mouseSpare
                else { return }
                
                // Update idling status
                if self.isActive && self.mouseInHideArea && !(KeyboardManager.command && event?.type == .leftMouseDown) {
                    self.idleHideArea()
                }
                
                if self.mouseInAlwaysHideArea {
                    self.idleAlwaysHideArea()
                }
                
                // Update external menu caches
                ExternalMenuBarManager.menuBarItems.forEach { $0.cache() }
                self.lastExternalMenus.removeAll()
                
                self.updateExternalMenusDispatch?.cancel()
                self.updateExternalMenusDispatch = .init {
                    self.lastExternalMenus = ExternalMenuBarManager.menuBarItems.flatMap {
                        $0.newWindowsNear
                    }
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
        idling.hide = false
        unidleAlwaysHideArea()
    }
    
    func unidleAlwaysHideArea() {
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
