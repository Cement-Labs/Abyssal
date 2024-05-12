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
        !Defaults[.theme].autoHideIcons && !Defaults[.isCollapsed]
    }
    
    func icons(collapses: Bool = Defaults[.isCollapsed]) -> (head: Icon, body: Icon, tail: Icon) {
        (
            head: collapses ? Defaults[.theme].headCollapsed : Defaults[.theme].headUncollapsed,
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
        
        head.button?.appearsDisabled = disabled
        body.button?.appearsDisabled = disabled
        tail.button?.appearsDisabled = disabled
        
        if disabled {
            head.targetAlpha = 1
            body.targetAlpha = 1
            tail.targetAlpha = 1
        }
        
        // Special judge for #map()
        
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
        
        guard Defaults[.autoShowsEnabled] || !Defaults[.isCollapsed] || !Defaults[.theme].autoHideIcons else {
            head.targetAlpha = 0
            body.targetAlpha = 0
            tail.targetAlpha = 0
            break map
        }
        
        if Defaults[.theme].autoHideIcons {
            head.targetAlpha = Defaults[.isCollapsed] ? 0 : icons().head.opacity
        } else {
            head.targetAlpha = icons().head.opacity
            
            body.targetAlpha = (
                !Defaults[.isCollapsed]
                || idling.hide
                || idling.alwaysHide
                || (Defaults[.autoShowsEnabled] && mouseSpare)
            ) ? icons().body.opacity : 0
            
            tail.targetAlpha = (
                idling.alwaysHide
                || (KeyboardHelper.triggers && mouseSpare)
            ) ? icons().tail.opacity : 0
        }
    } // End of map
        
        // Note: to collapses means to hide the status items and to expand the separators.
        
        // Head
        
        shouldTimersStop.flag = head.lerpAlpha() && shouldTimersStop.flag
        
    head: do {
        let collapses = !popoverShown && Defaults[.isCollapsed] && !(idling.hide || idling.alwaysHide) && !(Defaults[.autoShowsEnabled] && mouseSpare)
        
        head.targetLength = icons(collapses: collapses).head.width
        shouldTimersStop.flag = head.lerpLength() && shouldTimersStop.flag
    } // End of head
        
        // Body
        
        shouldTimersStop.flag = body.lerpAlpha() && shouldTimersStop.flag
        
    body: do {
        guard let x = body.origin?.x else { break body }
        
        let collapses = !popoverShown && Defaults[.isCollapsed] && !(idling.hide || idling.alwaysHide) && !(Defaults[.autoShowsEnabled] && mouseSpare)
        
        do {
            if !collapses && !body.wasUnstable {
                if body.targetLength <= 0 { body.targetLength = x + body.length - Helper.menuBarLeftEdge }
                
                body.length = body.targetLength
                body.wasUnstable = true
                
                if !Defaults[.reduceAnimationEnabled] { break body }
            }
            
            else if collapses && !body.wasUnstable {
                body.length = maxLength
                break body
            }
            
            else if body.wasUnstable {
                body.wasUnstable = !collapses || body.wasUnstable && x > Helper.menuBarLeftEdge + 5
            }
            
            
            
            if
                let lastOrigin = body.lastOrigin,
                body.lastCollapses != collapses || x != lastOrigin.x
            { body.targetLength = collapses ? max(0, x + body.length - Helper.menuBarLeftEdge) : icons().body.width }
            
            body.lastOrigin = body.origin
            body.lastCollapses = collapses
            
            shouldTimersStop.flag = body.lerpLength() && shouldTimersStop.flag
        }
    } // End of body
        
        // Tail
        
        shouldTimersStop.flag = tail.lerpAlpha() && shouldTimersStop.flag
        
    tail: do {
        guard let x = tail.origin?.x else { break tail }
        
        let collapses = !popoverShown && !(KeyboardHelper.triggers && ((Defaults[.isCollapsed] && !idling.hide) || mouseSpare)) && !idling.alwaysHide
        
        do {
            if !collapses && !tail.wasUnstable {
                if tail.targetLength <= 0 { tail.targetLength = x + tail.length - Helper.menuBarLeftEdge }
                
                tail.length = tail.targetLength
                tail.wasUnstable = true
                
                if !Defaults[.reduceAnimationEnabled] { break tail }
            }
            
            else if collapses && !tail.wasUnstable {
                tail.length = maxLength
                break tail
            }
            
            else if tail.wasUnstable {
                tail.wasUnstable = !collapses || tail.wasUnstable && x > Helper.menuBarLeftEdge + 5
            }
            
            
            
            if
                let lastOrigin = tail.lastOrigin,
                tail.lastCollapses != collapses || x != lastOrigin.x
            { tail.targetLength = collapses ? max(0, x + tail.length - Helper.menuBarLeftEdge) : icons().tail.width }
            
            tail.lastOrigin = tail.origin
            tail.lastCollapses = collapses
            
            shouldTimersStop.flag = tail.lerpLength() && shouldTimersStop.flag
        }
    } // End of tail
    }
    
    func map() {
        head.button?.image = icons().head.image
        body.button?.image = icons().body.image
        tail.button?.image = icons().tail.image
        
        guard Defaults[.autoShowsEnabled] || !Defaults[.isCollapsed] || !Defaults[.theme].autoHideIcons else {
            head.targetAlpha = 0
            body.targetAlpha = 0
            tail.targetAlpha = 0
            return
        }
        
        if !Defaults[.theme].autoHideIcons {
            // Special judge. See #update()
        } else if popoverShown || KeyboardHelper.triggers {
            head.button?.image = Defaults[.theme].headUncollapsed.image
            head.targetAlpha = icons().head.opacity
            body.targetAlpha = mouseSpare ? icons().body.opacity : 0
            tail.targetAlpha = mouseSpare ? icons().tail.opacity : 0
        } else {
            head.targetAlpha = !Defaults[.isCollapsed] ? icons().head.opacity : 0
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
