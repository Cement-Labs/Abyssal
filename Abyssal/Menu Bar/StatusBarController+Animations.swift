//
//  Animations.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit
import Defaults

extension StatusBarController {
    var disabled: Bool {
        autoHidesIcons
        && isInactive
    }
    
    var triggers: (body: Bool, tail: Bool) {
        (
            body: mouseOnStatusBar.value() && keyboardTriggers.value(),
            tail: mouseSpare.value() && keyboardTriggers.value()
        )
    }
    
    func icons(isActive: Bool = Defaults[.isActive]) -> (head: Icon, body: Icon, tail: Icon) {
        (
            head: isActive ? Defaults[.theme].headActive : Defaults[.theme].headInactive,
            body: Defaults[.theme].body,
            tail: Defaults[.theme].tail
        )
    }
    
    
    
    func triggerFeedback() {
        feedbackCount = 0
        startFeedbackTimer()
    }
    
    func triggerIgnoring() {
        ignoring = true
        startIgnoringTimer()
    }
    
    
    
    // MARK: - Convenient Constant Declearations
    
    // Positives
    
    var autoShows: Bool {
        Defaults[.autoShowsEnabled]
    }
    
    var isActive: Bool {
        !Defaults[.isActive]
    }
    
    var autoHidesIcons: Bool {
        !Defaults[.theme].autoHidesIcons
    }
    
    var idlingAny: Bool {
        idling.hide || idling.alwaysHide
    }
    
    var idlingAll: Bool {
        idling.hide && idling.alwaysHide
    }
    
    // Negatives
    
    var alwaysHides: Bool {
        !autoShows
    }
    
    var isInactive: Bool {
        !isActive
    }
    
    var alwaysShowsIcons: Bool {
        !autoHidesIcons
    }
    
    var idlingNone: Bool {
        !idlingAny
    }
    
    var idlingButNotAll: Bool {
        !idlingAll
    }
    
    
    
    func update() {
        if shouldTimersStop.flag {
            // Make abundant for completing animations
            if !(noAnimation || Defaults[.reduceAnimationEnabled]) && shouldTimersStop.count < 10 {
                shouldTimersStop.count += 1
            } else {
                shouldTimersStop = (flag: false, count: 0)
                stopFunctionalTimers()
            }
        } else {
            shouldTimersStop.count = 0
        }
        
        shouldTimersStop.flag = true
        
        // MARK: - Feedback
        
        feedback: do {
            let mouseNeedsUpdate = mouseWasSpareOrUnidled != mouseSpare.value()
            
            if
                isActive
                    && !popoverShown
                    && idlingNone
                    && autoShows
                    && mouseNeedsUpdate
            {
                mouseWasSpareOrUnidled = mouseSpare.value()
                triggerFeedback()
            }
        }
        
        // MARK: - Basic appearances
        
        appearances: do {
            head.button?.appearsDisabled = disabled
            body.button?.appearsDisabled = disabled
            tail.button?.appearsDisabled = disabled
            
            if disabled {
                head.targetAlpha = 1
                body.targetAlpha = 1
                tail.targetAlpha = 1
            }
        }
        
        // MARK: - Special Judge for #map()
        
        map: do {
            head.button?.image = icons().head.image
            body.button?.image = icons().body.image
            tail.button?.image = icons().tail.image
            
            guard !popoverShown else {
                head.targetAlpha = icons().head.opacity
                body.targetAlpha = icons().body.opacity
                tail.targetAlpha = icons().tail.opacity
                
                break map
            }
            
            guard
                autoShows
                    || isInactive
                    || alwaysShowsIcons
            else {
                head.targetAlpha = 0
                body.targetAlpha = 0
                tail.targetAlpha = 0
                
                break map
            }
            
            if Defaults[.theme].autoHidesIcons {
                head.targetAlpha = isActive ? 0 : icons().head.opacity
            } else {
                head.targetAlpha = icons().head.opacity
                
                body.targetAlpha = (
                    isInactive
                    || triggers.body
                    || idlingAny
                    || (autoShows && mouseSpare.value())
                ) ? icons().body.opacity : 0
                
                tail.targetAlpha = (
                    triggers.tail
                    || idling.alwaysHide
                ) ? icons().tail.opacity : 0
            }
        } // End of 'map'
        
        // MARK: - Head
        
        shouldTimersStop.flag &= head.lerpAlpha()
        
        head: do {
            let shouldActivate =
            isActive
            && !popoverShown
            && idlingNone
            && !(autoShows && mouseSpare.value())
            
            head.targetLength = icons(isActive: shouldActivate).head.width
            shouldTimersStop.flag &= head.lerpLength(noAnimation: noAnimation)
        } // End of 'head'
        
        // MARK: - Body
        
        shouldTimersStop.flag &= body.lerpAlpha()
        
        body: do {
            guard let x = body.origin?.x else { break body }
            
            let shouldActivate =
            isActive
            && !popoverShown
            && !triggers.body
            && idlingNone
            && !(autoShows && mouseSpare.value())
            
            do {
                if !shouldActivate && !body.wasUnstable {
                    if body.targetLength <= 0 {
                        body.targetLength = x + body.length - ScreenManager.menuBarLeftEdge
                    }
                    
                    body.applyLength()
                    body.wasUnstable = true
                    
                    if !(noAnimation || Defaults[.reduceAnimationEnabled]) { break body }
                }
                
                else if shouldActivate && !body.wasUnstable {
                    body.length = maxLength
                    break body
                }
                
                else if body.wasUnstable {
                    body.wasUnstable = !shouldActivate || body.wasUnstable && x > ScreenManager.menuBarLeftEdge + 5
                }
                
                
                
                if
                    let lastOrigin = body.lastOrigin,
                    body.wasActive != shouldActivate || x != lastOrigin.x
                {
                    body.targetLength = shouldActivate
                    ? max(0, x + body.length - ScreenManager.menuBarLeftEdge)
                    : icons().body.width
                }
                
                body.lastOrigin = body.origin
                body.wasActive = shouldActivate
                
                shouldTimersStop.flag &= body.lerpLength(noAnimation: noAnimation)
            }
        } // End of 'body'
        
        // MARK: - Tail
        
        shouldTimersStop.flag &= tail.lerpAlpha()
        
        tail: do {
            guard let x = tail.origin?.x else { break tail }
            
            let shouldActive =
            !popoverShown
            && !triggers.tail
            && !idling.alwaysHide
            
            do {
                if !shouldActive && !tail.wasUnstable {
                    if tail.targetLength <= 0 {
                        tail.targetLength = x + tail.length - ScreenManager.menuBarLeftEdge
                    }
                    
                    tail.applyLength()
                    tail.wasUnstable = true
                    
                    if !(noAnimation || Defaults[.reduceAnimationEnabled]) { break tail }
                }
                
                else if shouldActive && !tail.wasUnstable {
                    tail.length = maxLength
                    break tail
                }
                
                else if tail.wasUnstable {
                    tail.wasUnstable = !shouldActive || tail.wasUnstable && x > ScreenManager.menuBarLeftEdge + 5
                }
                
                
                
                if
                    let lastOrigin = tail.lastOrigin,
                    tail.wasActive != shouldActive || x != lastOrigin.x
                {
                    tail.targetLength = shouldActive
                    ? max(0, x + tail.length - ScreenManager.menuBarLeftEdge)
                    : icons().tail.width
                }
                
                tail.lastOrigin = tail.origin
                tail.wasActive = shouldActive
                
                shouldTimersStop.flag &= tail.lerpLength(noAnimation: noAnimation)
            }
        } // End of 'tail'
    }
    
    
    
    func map() {
        head.button?.image = icons().head.image
        body.button?.image = icons().body.image
        tail.button?.image = icons().tail.image
        
        guard autoShows || isInactive || alwaysShowsIcons else {
            head.targetAlpha = 0
            body.targetAlpha = 0
            tail.targetAlpha = 0
            return
        }
        
        if alwaysShowsIcons {
            // Special judge. See #update()
        } else if popoverShown {
            head.button?.image = Defaults[.theme].headInactive.image
            head.targetAlpha = icons().head.opacity
            body.targetAlpha = icons().body.opacity
            tail.targetAlpha = icons().tail.opacity
        } else if KeyboardManager.triggers {
            head.button?.image = Defaults[.theme].headInactive.image
            head.targetAlpha = icons().head.opacity
            body.targetAlpha = triggers.body ? icons().body.opacity : 0
            tail.targetAlpha = triggers.tail ? icons().tail.opacity : 0
        } else {
            head.targetAlpha = !Defaults[.isActive] ? icons().head.opacity : 0
            body.targetAlpha = 0
            tail.targetAlpha = 0
        }
    }
    
    func checkIdleStates() {
        if
            mouseSpare.value()
                && idlingAny
                && (mouseOverHead.value() || mouseOverBody.value() || mouseOverTail.value())
        {
            unidleHideArea()
            mouseWasSpareOrUnidled = false
        }
    }
}
