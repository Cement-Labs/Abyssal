//
//  Separator.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/25.
//

import Foundation
import AppKit
import Defaults

struct Separator {
    init(
        order: Int,
        _ itemsProvider: @escaping () -> [NSStatusItem]
    ) {
        self.order = order
        self.itemsProvider = itemsProvider
    }
    
    // MARK: - Stored Properties
    
    var order: Int
    
    var itemsProvider: () -> [NSStatusItem]
    
    var item: NSStatusItem {
        itemsProvider()[order]
    }
    
    // MARK: - Computed Properties
    
    var isVisible: Bool {
        get {
            item.isVisible
        }
        
        set(flag) {
            item.isVisible = flag
        }
    }
    
    var origin: NSPoint? {
        item.origin
    }
    
    var button: NSStatusBarButton? {
        item.button
    }
    
    var alpha: CGFloat? {
        get {
            item.button?.alphaValue
        }
        
        set(alpha) {
            item.button?.alphaValue = alpha ?? 0
        }
    }
    
    var length: CGFloat {
        get {
            item.length
        }
        
        set(legnth) {
            item.length = legnth
        }
    }
    
    var targetAlpha = CGFloat.zero
    var targetLength = CGFloat.zero
    
    var wasUnstable = false
    var wasActive = false
    
    var lastOrigin: NSPoint?
    
    var isAvailable: Bool {
        if let origin {
            return origin.x + length < ScreenManager.menuBarLeftEdge
        } else {
            return true
        }
    }
}

extension Separator {
    mutating func lerpAlpha() -> Bool {
        if let alpha {
            self.alpha = MathHelper.lerp(
                a: alpha,
                b: targetAlpha,
                ratio: MathHelper.lerpRatio,
                false
            )
            
            return MathHelper.approaching(alpha, targetAlpha, false)
        } else {
            return true
        }
    }
    
    mutating func lerpLength() -> Bool {
        if Defaults[.reduceAnimationEnabled] {
            length = targetLength
            return true
        } else {
            length = MathHelper.lerp(
                a: length,
                b: targetLength,
                ratio: MathHelper.lerpRatio
            )
            
            return MathHelper.approaching(length, targetLength)
        }
    }
    
    mutating func applyAlpha() {
        alpha = targetAlpha
    }
    
    mutating func applyLength() {
        length = targetLength
    }
}
