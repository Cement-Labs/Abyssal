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
    
    var lastOrigin: NSPoint?
    var lastCollapses = false
}

extension Separator {
    mutating func lerpAlpha() -> Bool {
        if let alpha {
            self.alpha = Helper.lerp(
                a: alpha,
                b: targetAlpha,
                ratio: Helper.lerpRatio,
                false
            )
            
            return Helper.approaching(alpha, targetAlpha, false)
        } else {
            return true
        }
    }
    
    mutating func lerpLength() -> Bool {
        if Defaults[.reduceAnimationEnabled] {
            length = targetLength
            return true
        } else {
            length = Helper.lerp(
                a: length,
                b: targetLength,
                ratio: Helper.lerpRatio
            )
            
            return Helper.approaching(length, targetLength)
        }
    }
}
