//
//  AnimationConstants.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit

extension StatusBarController {
	
    static var lerpRatio: Float16 {
        let baseValue: Float16 = 0.69
        return baseValue * (Helper.Keyboard.shift ? 0.25 : 1)
	}
	
}

var lastOriginXs: (b: CGFloat, t: CGFloat) = (b: 0, t: 0)

var lastFlags: (b: Bool, t: Bool) = (b: false, t: false)

var wasUnstable: (b: Bool, t: Bool) = (b: false, t: false)



var mouseWasOnStatusBarOrUnidled: Bool = false

var feedbackCount: Int = 0



var maxLength: CGFloat {
    return Helper.Screen.maxWidth ?? 10000 // To cover all screens
}

var popoverShown: Bool {
    return Helper.delegate?.popover.isShown ?? false
}

extension StatusBarController {
    
    func update() {
        guard available else { return }
        
        // Process feedback
        
        if Data.collapsed && !idling.hide && !idling.alwaysHide && Data.autoShows && !(Helper.delegate?.popover.isShown ?? false)
            &&  !(idling.hide && idling.alwaysHide) && ((!mouseWasOnStatusBarOrUnidled && mouseOnStatusBar) || (mouseWasOnStatusBarOrUnidled && !mouseOnStatusBar))
        {
            guard feedbackCount < Data.feedbackAttributes.repeats else {
                mouseWasOnStatusBarOrUnidled = mouseOnStatusBar
                feedbackCount = 0
                return
            }
            feedbackCount += 1
            NSHapticFeedbackManager.defaultPerformer.perform(Data.feedbackAttributes.pattern, performanceTime: .now)
        }
        
        // Modify basic appearance
        
        head.button?.appearsDisabled = !Data.theme.autoHideIcons && !Data.collapsed
        body.button?.appearsDisabled = !Data.theme.autoHideIcons && !Data.collapsed
        tail.button?.appearsDisabled = !Data.theme.autoHideIcons && !Data.collapsed
        
        // Head
        
        if let alpha = self.head.button?.alphaValue, let alpha = Int8(exactly: round(alpha * 127)) {
            self.head.button?.alphaValue = Helper.lerp(
                a: alpha,
                b: self.alphaValues.h,
                ratio: StatusBarController.lerpRatio,
                false
            ).cgFloat / 127.0
        }
        
        DispatchQueue.main.async {
            let flag = !popoverShown && Data.collapsed && !(self.idling.hide || self.idling.alwaysHide) && (!Data.autoShows || !self.mouseOnStatusBar)
            
            self.lengths.h = flag ? Data.theme.iconWidthAlt : Data.theme.iconWidth
            
            guard let length = Int32(exactly: self.head.length) else { return }
            
            Helper.lerpAsync(
                a: length,
                b: self.lengths.h,
                ratio: StatusBarController.lerpRatio
            ) { result in
                self.head.length = result.cgFloat
            }
        }
        
        // Body
        
        if let alpha = self.body.button?.alphaValue, let alpha = Int8(exactly: round(alpha * 127)) {
            self.body.button?.alphaValue = Helper.lerp(
                a: alpha,
                b: self.alphaValues.b,
                ratio: StatusBarController.lerpRatio,
                false
            ).cgFloat / 127.0
        }
        
        do {
            let flag = !popoverShown && Data.collapsed && !(self.idling.hide || self.idling.alwaysHide) && (!Data.autoShows || !self.mouseOnStatusBar)
            
            guard
                let x = self.body.origin?.x,
                let length = Int32(exactly: self.body.length)
            else { return }
            
            DispatchQueue.main.async {
                if !flag && !wasUnstable.b {
                    if self.lengths.b <= 0 { self.lengths.b = Int32(exactly: x + length.cgFloat - Helper.menuBarLeftEdge) ?? 0 }
                    
                    self.body.length = self.lengths.b.cgFloat
                    wasUnstable.b = true
                    return
                } else if flag && !wasUnstable.b {
                    self.body.length = maxLength
                    return
                } else if wasUnstable.b {
                    wasUnstable.b = !flag || wasUnstable.b && x > Helper.menuBarLeftEdge + 5
                }
                
                if
                    let origin = self.body.origin,
                    lastFlags.b != flag || origin.x != lastOriginXs.b
                {
                    self.lengths.b = flag ? Int32(exactly: max(0, x + length.cgFloat - Helper.menuBarLeftEdge)) ?? 0 : Data.theme.iconWidth
                    lastOriginXs.b = origin.x
                    lastFlags.b = flag
                }
                
                if Data.reduceAnimation {
                    self.body.length = self.lengths.b.cgFloat
                } else {
                    Helper.lerpAsync(
                        a: length,
                        b: self.lengths.b,
                        ratio: StatusBarController.lerpRatio
                    ) { result in
                        self.body.length = result.cgFloat
                    }
                }
            }
        }
        
        // Tail
        
        if let alpha = self.tail.button?.alphaValue, let alpha = Int8(exactly: round(alpha * 127)) {
            self.tail.button?.alphaValue =  Helper.lerp(
                a: alpha,
                b: self.alphaValues.t,
                ratio: StatusBarController.lerpRatio,
                false
            ).cgFloat / 127.0
        }
        
        do {
            let flag = !popoverShown && !(Helper.Keyboard.command && ((Data.collapsed && !self.idling.hide) || self.mouseOnStatusBar)) && !self.idling.alwaysHide
            
            guard
                let x = self.tail.origin?.x,
                let length = Int32(exactly: self.tail.length)
            else { return }
            
            DispatchQueue.main.async {
                if !flag && !wasUnstable.t {
                    if self.lengths.t <= 0 { self.lengths.t = Int32(exactly: x + length.cgFloat - Helper.menuBarLeftEdge) ?? 0 }
                    
                    self.tail.length = self.lengths.t.cgFloat
                    wasUnstable.t = true
                    return
                } else if flag && !wasUnstable.t {
                    self.tail.length = maxLength
                    return
                } else if wasUnstable.t {
                    wasUnstable.t = !flag || wasUnstable.t && x > Helper.menuBarLeftEdge + 5
                }
                
                if
                    let origin = self.tail.origin,
                    lastFlags.t != flag || origin.x != lastOriginXs.t
                {
                    self.lengths.t = flag ? Int32(exactly: max(0, x + length.cgFloat - Helper.menuBarLeftEdge)) ?? 0 : Data.theme.iconWidth
                    lastOriginXs.t = origin.x
                    lastFlags.t = flag
                }
                
                if Data.reduceAnimation {
                    self.tail.length = self.lengths.t.cgFloat
                } else {
                    Helper.lerpAsync(
                        a: length,
                        b: self.lengths.t,
                        ratio: StatusBarController.lerpRatio
                    ) { result in
                        self.tail.length = result.cgFloat
                    }
                }
            }
        }
        
        // Special judge for #map()
        
        if !Data.theme.autoHideIcons {
            let popoverShown = Helper.delegate?.popover.isShown ?? false
            
            alphaValues.h = 127
            
            alphaValues.b = (
                popoverShown || !Data.collapsed
                || idling.hide || idling.alwaysHide
                || (Data.autoShows && mouseOnStatusBar)
            ) ? 127 : 0
            
            alphaValues.t = (
                popoverShown || idling.alwaysHide
                || (mouseOnStatusBar && (Helper.Keyboard.command || Helper.Keyboard.option))
            ) ? 127 : 0
        }
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
        
        if
            mouseOnStatusBar
                && (idling.hide || idling.alwaysHide)
                && (mouseOverHead || mouseOverBody || mouseOverTail)
        {
            unidleHideArea()
            mouseWasOnStatusBarOrUnidled = false
        }
        
        if !Data.theme.autoHideIcons {
            // Special judge. See #update()
        } else if popoverShown || (mouseOnStatusBar && (Helper.Keyboard.command || Helper.Keyboard.option)) {
            head.button?.image = Data.theme.headUncollapsed
            alphaValues.h = 127
            alphaValues.b = 127
            alphaValues.t = 127
        } else {
            alphaValues.h = !Data.collapsed ? 127 : 0
            alphaValues.b = 0
            alphaValues.t = 0
        }
    }
    
}
