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
        let baseValue: Float16 = 0.66
		return baseValue * (Helper.Keyboard.shift ? 0.25 : 1)
	}
	
}

var lastOriginXs: (b: Float16, t: Float16) = (b: 0, t: 0)

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
        
        if let alpha = self.head.button?.alphaValue.float16 {
            self.head.button?.alphaValue = Helper.lerp(
                a: alpha,
                b: self.alphaValues.h,
                ratio: StatusBarController.lerpRatio,
                false
            ).cgFloat
        }
        
        DispatchQueue.main.async {
            let flag = !popoverShown && Data.collapsed && !(self.idling.hide || self.idling.alwaysHide) && (!Data.autoShows || !self.mouseOnStatusBar)
            
            self.lengths.h = Int64(flag ? Data.theme.iconWidthAlt : Data.theme.iconWidth)
            
            Helper.lerpAsync(
                a: self.head.length.float16,
                b: self.lengths.h.float16,
                ratio: StatusBarController.lerpRatio
            ) { result in
                self.head.length = result.cgFloat
            }
        }
        
        // Body
        
        if let alpha = self.body.button?.alphaValue.float16 {
            self.body.button?.alphaValue = Helper.lerp(
                a: alpha,
                b: self.alphaValues.b,
                ratio: StatusBarController.lerpRatio,
                false
            ).cgFloat
        }
        
        do {
            let flag = !popoverShown && Data.collapsed && !(self.idling.hide || self.idling.alwaysHide) && (!Data.autoShows || !self.mouseOnStatusBar)
            
            guard let x = self.body.origin?.x.float16 else { return }
            let length = self.body.length.float16
            
            DispatchQueue.main.async {
                if !flag && !wasUnstable.b {
                    if self.lengths.b <= 0 { self.lengths.b = Int64(x + length - Helper.menuBarLeftEdge) }
                    
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
                    lastFlags.b != flag || origin.x.float16 != lastOriginXs.b
                {
                    self.lengths.b = flag ? Int64(max(0, x + length - Helper.menuBarLeftEdge)) : Data.theme.iconWidth
                    lastOriginXs.b = origin.x.float16
                    lastFlags.b = flag
                }
                
                if Data.reduceAnimation {
                    self.body.length = self.lengths.b.cgFloat
                } else {
                    Helper.lerpAsync(
                        a: length,
                        b: self.lengths.b.float16,
                        ratio: StatusBarController.lerpRatio
                    ) { result in
                        self.body.length = result.cgFloat
                    }
                }
            }
        }
        
        // Tail
        
        if let alpha = self.tail.button?.alphaValue.float16 {
            self.tail.button?.alphaValue =  Helper.lerp(
                a: alpha,
                b: self.alphaValues.t,
                ratio: StatusBarController.lerpRatio,
                false
            ).cgFloat
        }
        
        do {
            let flag = !popoverShown && !(Helper.Keyboard.command && ((Data.collapsed && !self.idling.hide) || self.mouseOnStatusBar)) && !self.idling.alwaysHide
            
            guard let x = self.tail.origin?.x.float16 else { return }
            let length = self.tail.length.float16
            
            DispatchQueue.main.async {
                if !flag && !wasUnstable.t {
                    if self.lengths.t <= 0 { self.lengths.t = Int64(x + length - Helper.menuBarLeftEdge) }
                    
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
                    lastFlags.t != flag || origin.x.float16 != lastOriginXs.t
                {
                    self.lengths.t = flag ? Int64(max(0, x + length - Helper.menuBarLeftEdge)) : Data.theme.iconWidth
                    lastOriginXs.t = origin.x.float16
                    lastFlags.t = flag
                }
                
                if Data.reduceAnimation {
                    self.tail.length = self.lengths.t.cgFloat
                } else {
                    Helper.lerpAsync(
                        a: self.tail.length.float16,
                        b: self.lengths.t.float16,
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
            
            alphaValues.h = 1
            
            alphaValues.b = (
                popoverShown || !Data.collapsed
                || idling.hide || idling.alwaysHide
                || (Data.autoShows && mouseOnStatusBar)
            ) ? 1 : 0
            
            alphaValues.t = (
                popoverShown || idling.alwaysHide
                || (mouseOnStatusBar && (Helper.Keyboard.command || Helper.Keyboard.option))
            ) ? 1 : 0
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
            alphaValues.h = 1
            alphaValues.b = 1
            alphaValues.t = 1
        } else {
            alphaValues.h = !Data.collapsed ? 1 : 0
            alphaValues.b = 0
            alphaValues.t = 0
        }
    }
    
}
