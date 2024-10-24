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
        (autoHidesIcons && isFunctioning)
        || mouseDragging.value()
    }
    
    var triggers: (body: Bool, tail: Bool) {
        (
            body: mouseOnStatusBar.value() && keyboardTriggers.value(),
            tail: mouseSpare.value() && keyboardTriggers.value()
        )
    }
    
    func icons(isActive: Bool = Defaults[.isStandby]) -> (head: Icon, body: Icon, tail: Icon) {
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
    
    // positives
    
    var autoShows: Bool {
        Defaults[.autoShowsEnabled]
    }
    
    var isStandby: Bool {
        !Defaults[.isStandby]
    }
    
    var autoHidesIcons: Bool {
        Defaults[.theme].autoHidesIcons
    }
    
    var idlingAny: Bool {
        idling.hidden || idling.alwaysHidden
    }
    
    var idlingAll: Bool {
        idling.hidden && idling.alwaysHidden
    }
    
    // negatives
    
    var alwaysHiddens: Bool {
        !autoShows
    }
    
    var isFunctioning: Bool {
        !isStandby
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
            // make abundant for completing animations
            if !Defaults[.reduceAnimationEnabled] && shouldTimersStop.count < 10 {
                shouldTimersStop.count += 1
            } else {
                shouldTimersStop = (flag: false, count: 0)
                terminate()
            }
        } else {
            shouldTimersStop.count = 0
        }
        
        shouldTimersStop.flag = true
        
        // MARK: - Feedback
        
        feedback: do {
            let mouseNeedsUpdate = mouseWasSpareOrUnidled != mouseSpare.value()
            
            if
                isStandby
                    && !isActive
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
            // disabled button appearances are hard to recognise
            /*
            head.button?.appearsDisabled = disabled
            body.button?.appearsDisabled = disabled
            tail.button?.appearsDisabled = disabled
            
            if disabled {
                head.targetAlpha = 1
                body.targetAlpha = 1
                tail.targetAlpha = 1
            }
             */
            
            // simply just reset opacities is good
            if disabled {
                head.targetAlpha = icons().head.opacity
                body.targetAlpha = icons().body.opacity
                tail.targetAlpha = icons().tail.opacity
            }
        }
        
        // MARK: - Special Judge for #map()
        
        map: do {
            head.button?.image = icons().head.image
            body.button?.image = icons().body.image
            tail.button?.image = icons().tail.image
            
            guard !disabled else {
                break map
            }
            
            guard !isActive else {
                head.targetAlpha = icons().head.opacity
                body.targetAlpha = icons().body.opacity
                tail.targetAlpha = icons().tail.opacity
                
                break map
            }
            
            guard
                autoShows
                    || isFunctioning
                    || alwaysShowsIcons
            else {
                head.targetAlpha = 0
                body.targetAlpha = 0
                tail.targetAlpha = 0
                
                break map
            }
            
            if autoHidesIcons {
                head.targetAlpha = isStandby ? 0 : icons().head.opacity
            } else {
                head.targetAlpha = icons().head.opacity
                
                body.targetAlpha = (
                    isFunctioning
                    || triggers.body
                    || idlingAny
                    || (autoShows && mouseSpare.value())
                ) ? icons().body.opacity : 0
                
                tail.targetAlpha = (
                    triggers.tail
                    || idling.alwaysHidden
                ) ? icons().tail.opacity : 0
            }
        } // end of `map`
        
        // MARK: - Head
        
        shouldTimersStop.flag &= head.lerpAlpha(noAnimation: noAnimation)
        
        head: do {
            let shouldActivate =
            isStandby
            && !isActive
            && idlingNone
            && !(autoShows && mouseSpare.value())
            
            head.targetLength = icons(isActive: shouldActivate).head.width
            shouldTimersStop.flag &= head.lerpLength(noAnimation: noAnimation)
        } // end of `head`
        
        // MARK: - Body
        
        shouldTimersStop.flag &= body.lerpAlpha(noAnimation: noAnimation)
        
        body: do {
            guard let x = body.origin?.x else { break body }
            
            let shouldActivate =
            isStandby
            && !isActive
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
        } // end of `body`
        
        // MARK: - Tail
        
        shouldTimersStop.flag &= tail.lerpAlpha(noAnimation: noAnimation)
        
        tail: do {
            guard let x = tail.origin?.x else { break tail }
            
            let shouldActive =
            !isActive
            && !triggers.tail
            && !idling.alwaysHidden
            
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
        } // end of `tail`
    }
    
    
    
    func map() {
        head.button?.image = icons().head.image
        body.button?.image = icons().body.image
        tail.button?.image = icons().tail.image
        
        guard autoShows || isFunctioning || alwaysShowsIcons else {
            // always hidden
            head.targetAlpha = 0
            body.targetAlpha = 0
            tail.targetAlpha = 0
            return
        }
        
        if alwaysShowsIcons {
            // special judge. See #update()
        } else if isActive {
            // popover shown, display all
            
            head.button?.image = Defaults[.theme].headInactive.image
            
            head.targetAlpha = icons().head.opacity
            body.targetAlpha = icons().body.opacity
            tail.targetAlpha = icons().tail.opacity
        } else if keyboardTriggers.value() {
            // keyboard triggers, display triggered appearances
            
            head.button?.image = Defaults[.theme].headInactive.image
            
            head.targetAlpha = icons().head.opacity
            body.targetAlpha = triggers.body ? icons().body.opacity : 0
            tail.targetAlpha = triggers.tail ? icons().tail.opacity : 0
        } else {
            // auto hide icons
            
            head.targetAlpha = isFunctioning ? icons().head.opacity : 0
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
            unidleHiddenArea()
            mouseWasSpareOrUnidled = false
        }
    }
}
