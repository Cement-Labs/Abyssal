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
    
    func triggerFeedback() {
        feedbackCount = 0
        startFeedbackTimer()
    }
    
    func triggerIgnoring() {
        ignoring = true
        startIgnoringTimer()
    }
    
    func update() {
        if shouldTimersStop.flag {
            // Make abundant for completing animations
            if !Defaults[.reduceAnimationEnabled] && shouldTimersStop.count < 10 {
                shouldTimersStop.count += 1
            } else {
                shouldTimersStop = (flag: false, count: 0)
                stopFunctionalTimers()
            }
        } else {
            shouldTimersStop.count = 0
        }
        
        shouldTimersStop.flag = true
        
        // Process feedback
        
        let mouseNeedsUpdate = mouseWasSpareOrUnidled != mouseSpare
        
        if Defaults[.isCollapsed] && !idling.hide && !idling.alwaysHide && Defaults[.autoShowsEnabled] && !popoverShown
            && !(idling.hide && idling.alwaysHide) && mouseNeedsUpdate
        {
            mouseWasSpareOrUnidled = mouseSpare
            triggerFeedback()
        }
        
        // Basic appearances
        
        head.button?.appearsDisabled = !Defaults[.theme].autoHideIcons && !Defaults[.isCollapsed]
        body.button?.appearsDisabled = !Defaults[.theme].autoHideIcons && !Defaults[.isCollapsed]
        tail.button?.appearsDisabled = !Defaults[.theme].autoHideIcons && !Defaults[.isCollapsed]
        
        // Special judge for #map()
        
    map: do {
        head.button?.image = Defaults[.isCollapsed] ? Defaults[.theme].headCollapsed : Defaults[.theme].headUncollapsed
        body.button?.image = Defaults[.theme].body
        tail.button?.image = Defaults[.theme].tail
        
        guard !popoverShown else {
            head.targetAlpha = 1
            body.targetAlpha = 1
            tail.targetAlpha = 1
            break map
        }
        
        guard Defaults[.autoShowsEnabled] || !Defaults[.isCollapsed] || !Defaults[.theme].autoHideIcons else {
            head.targetAlpha = 0
            body.targetAlpha = 0
            tail.targetAlpha = 0
            break map
        }
        
        if Defaults[.theme].autoHideIcons {
            head.targetAlpha = Defaults[.isCollapsed] ? 0 : 1
        } else {
            head.targetAlpha = 1
            
            body.targetAlpha = (
                !Defaults[.isCollapsed]
                || idling.hide
                || idling.alwaysHide
                || (Defaults[.autoShowsEnabled] && mouseSpare)
            ) ? 1 : 0
            
            tail.targetAlpha = (
                idling.alwaysHide
                || (KeyboardHelper.modifiers && mouseSpare)
            ) ? 1 : 0
        }
    } // End of map
        
        // Note: to collapse means to hide the status items and to expand the separators.
        
        // Head
        
        shouldTimersStop.flag = head.lerpAlpha() && shouldTimersStop.flag
        
    head: do {
        let collapse = !popoverShown && Defaults[.isCollapsed] && !(idling.hide || idling.alwaysHide) && !(Defaults[.autoShowsEnabled] && mouseSpare)
        
        head.targetLength = collapse ? Defaults[.theme].iconWidthExpanded : Defaults[.theme].iconWidth
        shouldTimersStop.flag = head.lerpLength() && shouldTimersStop.flag
    } // End of head
        
        // Body
        
        shouldTimersStop.flag = body.lerpAlpha() && shouldTimersStop.flag
        
    body: do {
        guard let x = body.origin?.x else { break body }
        
        let collapse = !popoverShown && Defaults[.isCollapsed] && !(idling.hide || idling.alwaysHide) && !(Defaults[.autoShowsEnabled] && mouseSpare)
        
        do {
            if !collapse && !body.wasUnstable {
                if body.targetLength <= 0 { body.targetLength = x + body.length - Helper.menuBarLeftEdge }
                
                body.length = body.targetLength
                body.wasUnstable = true
                
                if !Defaults[.reduceAnimationEnabled] { break body }
            }
            
            else if collapse && !body.wasUnstable {
                body.length = maxLength
                break body
            }
            
            else if body.wasUnstable {
                body.wasUnstable = !collapse || body.wasUnstable && x > Helper.menuBarLeftEdge + 5
            }
            
            
            
            if
                let lastOrigin = body.lastOrigin,
                body.lastCollapse != collapse || x != lastOrigin.x
            { body.targetLength = collapse ? max(0, x + body.length - Helper.menuBarLeftEdge) : Defaults[.theme].iconWidth }
            
            body.lastOrigin = body.origin
            body.lastCollapse = collapse
            
            shouldTimersStop.flag = body.lerpLength() && shouldTimersStop.flag
        }
    } // End of body
        
        // Tail
        
        shouldTimersStop.flag = tail.lerpAlpha() && shouldTimersStop.flag
        
    tail: do {
        guard let x = tail.origin?.x else { break tail }
        
        let collapse = !popoverShown && !(KeyboardHelper.modifiers && ((Defaults[.isCollapsed] && !idling.hide) || mouseSpare)) && !idling.alwaysHide
        
        do {
            if !collapse && !tail.wasUnstable {
                if tail.targetLength <= 0 { tail.targetLength = x + tail.length - Helper.menuBarLeftEdge }
                
                tail.length = tail.targetLength
                tail.wasUnstable = true
                
                if !Defaults[.reduceAnimationEnabled] { break tail }
            }
            
            else if collapse && !tail.wasUnstable {
                tail.length = maxLength
                break tail
            }
            
            else if tail.wasUnstable {
                tail.wasUnstable = !collapse || tail.wasUnstable && x > Helper.menuBarLeftEdge + 5
            }
            
            
            
            if
                let lastOrigin = tail.lastOrigin,
                tail.lastCollapse != collapse || x != lastOrigin.x
            { tail.targetLength = collapse ? max(0, x + tail.length - Helper.menuBarLeftEdge) : Defaults[.theme].iconWidth }
            
            tail.lastOrigin = tail.origin
            tail.lastCollapse = collapse
            
            shouldTimersStop.flag = tail.lerpLength() && shouldTimersStop.flag
        }
    } // End of tail
    }
    
    func map() {
        head.button?.image = Defaults[.isCollapsed] ? Defaults[.theme].headCollapsed : Defaults[.theme].headUncollapsed
        body.button?.image = Defaults[.theme].body
        tail.button?.image = Defaults[.theme].tail
        
        guard Defaults[.autoShowsEnabled] || !Defaults[.isCollapsed] || !Defaults[.theme].autoHideIcons else {
            head.targetAlpha = 0
            body.targetAlpha = 0
            tail.targetAlpha = 0
            return
        }
        
        if !Defaults[.theme].autoHideIcons {
            // Special judge. See #update()
        } else if popoverShown || KeyboardHelper.modifiers {
            head.button?.image = Defaults[.theme].headUncollapsed
            head.targetAlpha = 1
            body.targetAlpha = mouseSpare ? 1 : 0
            tail.targetAlpha = mouseSpare ? 1 : 0
        } else {
            head.targetAlpha = !Defaults[.isCollapsed] ? 1 : 0
            body.targetAlpha = 0
            tail.targetAlpha = 0
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
