//
//  Animations.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit

extension StatusBarController {
    
    static var lerpRatio: CGFloat {
        let baseValue = 0.42
        return baseValue * (Helper.Keyboard.shift ? 0.25 : 1) // Slow down when shift key is down
    }
    
}

extension StatusBarController {
    
    func triggerFeedback() {
        feedbackCount = 0
        startFeedbackTimer()
    }
    
    func triggerIgnoring() {
        ignoring = true
        startIgnoringTimer()
    }
    
    func update() {
        guard available else { return }
        
        if shouldTimersStop.flag {
            // Make abundant for completing animations
            if shouldTimersStop.count >= 5 {
                shouldTimersStop = (flag: false, count: 0)
                stopFunctionalTimers()
            } else {
                shouldTimersStop.count += 1
            }
        } else {
            shouldTimersStop.count = 0
        }
        
        shouldTimersStop.flag = true
        
        // Process feedback
        
        let mouseNeedsUpdate = mouseWasSpareOrUnidled != mouseSpare
        
        if Data.collapsed && !idling.hide && !idling.alwaysHide && Data.autoShows && !popoverShown
            && !(idling.hide && idling.alwaysHide) && mouseNeedsUpdate
        {
            mouseWasSpareOrUnidled = mouseSpare
            triggerFeedback()
        }
        
        // Basic appearances
        
        head.button?.appearsDisabled = !Data.theme.autoHideIcons && !Data.collapsed
        body.button?.appearsDisabled = !Data.theme.autoHideIcons && !Data.collapsed
        tail.button?.appearsDisabled = !Data.theme.autoHideIcons && !Data.collapsed
        
        // Special judge for #map()
        
    map: do {
        head.button?.image = Data.collapsed ? Data.theme.headCollapsed : Data.theme.headUncollapsed
        body.button?.image = Data.theme.separator
        tail.button?.image = Data.theme.tail
        
        guard !popoverShown else {
            alphaValues.h = 1
            alphaValues.b = 1
            alphaValues.t = 1
            break map
        }
        
        guard Data.autoShows || !Data.collapsed || !Data.theme.autoHideIcons else {
            alphaValues.h = 0
            alphaValues.b = 0
            alphaValues.t = 0
            break map
        }
        
        if Data.theme.autoHideIcons {
            alphaValues.h = Data.collapsed ? 0 : 1
        } else {
            alphaValues.h = 1
            
            alphaValues.b = (
                !Data.collapsed
                || idling.hide
                || idling.alwaysHide
                || (Data.autoShows && mouseSpare)
            ) ? 1 : 0
            
            alphaValues.t = (
                idling.alwaysHide
                || (Helper.Keyboard.modifiers && mouseSpare)
            ) ? 1 : 0
        }
    } // End of map
        
        // Head
        
        if let alpha = head.button?.alphaValue {
            head.button?.alphaValue = Helper.lerp(
                a: alpha,
                b: alphaValues.h,
                ratio: StatusBarController.lerpRatio,
                false
            )
            
            shouldTimersStop.flag = shouldTimersStop.flag && Helper.approaching(alpha, alphaValues.h, false)
        }
        
    head: do {
        let flag = !popoverShown && Data.collapsed && !(idling.hide || idling.alwaysHide) && !(Data.autoShows && mouseSpare)
        
        lengths.h = flag ? Data.theme.iconWidthAlt : Data.theme.iconWidth
        
        head.length = Helper.lerp(
            a: head.length,
            b: lengths.h,
            ratio: StatusBarController.lerpRatio
        )
        
        shouldTimersStop.flag = shouldTimersStop.flag && Helper.approaching(head.length, lengths.h)
    } // End of head
        
        // Body
        
        if let alpha = body.button?.alphaValue {
            body.button?.alphaValue = Helper.lerp(
                a: alpha,
                b: alphaValues.b,
                ratio: StatusBarController.lerpRatio,
                false
            )
            
            shouldTimersStop.flag = shouldTimersStop.flag && Helper.approaching(alpha, alphaValues.b, false)
        }
        
    body: do {
        let flag = !popoverShown && Data.collapsed && !(idling.hide || idling.alwaysHide) && !(Data.autoShows && mouseSpare)
        
        guard let x = body.origin?.x else { break body }
        let length = body.length
        
        do {
            if !flag && !wasUnstable.b {
                if lengths.b <= 0 { lengths.b = x + length - Helper.menuBarLeftEdge }
                
                body.length = lengths.b
                wasUnstable.b = true
                
                if !Data.reduceAnimation {
                    return
                }
            } else if flag && !wasUnstable.b {
                body.length = maxLength
                return
            } else if wasUnstable.b {
                wasUnstable.b = !flag || wasUnstable.b && x > Helper.menuBarLeftEdge + 5
            }
            
            if
                let origin = body.origin,
                lastFlags.b != flag || origin.x != lastOriginXs.b
            {
                lengths.b = flag ? max(0, x + length - Helper.menuBarLeftEdge) : Data.theme.iconWidth
                lastOriginXs.b = origin.x
                lastFlags.b = flag
            }
            
            if Data.reduceAnimation {
                body.length = lengths.b
            } else {
                body.length = Helper.lerp(
                    a: length,
                    b: lengths.b,
                    ratio: StatusBarController.lerpRatio
                )
                
                shouldTimersStop.flag = shouldTimersStop.flag && Helper.approaching(body.length, lengths.b)
            }
        }
    } // End of body
        
        // Tail
        
        if let alpha = tail.button?.alphaValue {
            tail.button?.alphaValue =  Helper.lerp(
                a: alpha,
                b: alphaValues.t,
                ratio: StatusBarController.lerpRatio,
                false
            )
            
            shouldTimersStop.flag = shouldTimersStop.flag && Helper.approaching(alpha, alphaValues.t, false)
        }
        
    tail: do {
        let flag = !popoverShown && !(Helper.Keyboard.modifiers && ((Data.collapsed && !idling.hide) || mouseSpare)) && !idling.alwaysHide
        
        guard let x = tail.origin?.x else { break tail }
        let length = tail.length
        
        do {
            if !flag && !wasUnstable.t {
                if lengths.t <= 0 { lengths.t = x + length - Helper.menuBarLeftEdge }
                
                tail.length = lengths.t
                wasUnstable.t = true
                
                if !Data.reduceAnimation { break tail }
            } else if flag && !wasUnstable.t {
                tail.length = maxLength
                return
            } else if wasUnstable.t {
                wasUnstable.t = !flag || wasUnstable.t && x > Helper.menuBarLeftEdge + 5
            }
            
            if
                let origin = tail.origin,
                lastFlags.t != flag || origin.x != lastOriginXs.t
            {
                lengths.t = flag ? max(0, x + length - Helper.menuBarLeftEdge) : Data.theme.iconWidth
                lastOriginXs.t = origin.x
                lastFlags.t = flag
            }
            
            if Data.reduceAnimation {
                tail.length = lengths.t
            } else {
                tail.length = Helper.lerp(
                    a: length,
                    b: lengths.t,
                    ratio: StatusBarController.lerpRatio
                )
                
                shouldTimersStop.flag = shouldTimersStop.flag && Helper.approaching(tail.length, lengths.t)
            }
        }
    } // End of tail
    }
    
    func map() {
        guard available else { return }
        
        head.button?.image = Data.collapsed ? Data.theme.headCollapsed : Data.theme.headUncollapsed
        body.button?.image = Data.theme.separator
        tail.button?.image = Data.theme.tail
        
        guard Data.autoShows || !Data.collapsed || !Data.theme.autoHideIcons else {
            alphaValues.h = 0
            alphaValues.b = 0
            alphaValues.t = 0
            return
        }
        
        if !Data.theme.autoHideIcons {
            // Special judge. See #update()
        } else if popoverShown || Helper.Keyboard.modifiers {
            head.button?.image = Data.theme.headUncollapsed
            alphaValues.h = 1
            alphaValues.b = mouseSpare ? 1 : 0
            alphaValues.t = mouseSpare ? 1 : 0
        } else {
            alphaValues.h = !Data.collapsed ? 1 : 0
            alphaValues.b = 0
            alphaValues.t = 0
        }
    }
    
    func checkIdleStates() {
        if
            mouseSpare
                && (idling.hide || idling.alwaysHide)
                && (mouseOverHead || mouseOverBody || mouseOverTail)
        {
            unidleHideArea()
            mouseWasSpareOrUnidled = false
        }
    }
    
}
