//
//  FillOnHoverBox.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

class FillOnHoverBox: NSBox {
    private var hoverColor: NSColor = NSColor.clear
    private var fallbackColor: NSColor?
    private var overrideColor: NSColor?
    
    private var borderHoverColor: NSColor = NSColor.clear
    private var borderFallbackColor: NSColor?
    private var borderOverrideColor: NSColor?
    
    private var isHovered: Bool = false
    
    
    
    public func setHoverColor(
        _ color: NSColor
    ) {
        self.hoverColor = color
        updateColors()
    }
    
    public func setFallbackColor(
        _ color: NSColor? = nil
    ) {
        self.fallbackColor = color
        updateColors()
    }
    
    public func setOverrideColor(
        _ color: NSColor? = nil
    ) {
        self.overrideColor = color
        updateColors()
    }
    
    
    
    public func setBorderHoverColor(
        _ color: NSColor
    ) {
        self.borderHoverColor = color
        updateColors()
    }
    
    public func setBorderFallbackColor(
        _ color: NSColor? = nil
    ) {
        self.borderFallbackColor = color
        updateColors()
    }
    
    public func setBorderOverrideColor(
        _ color: NSColor? = nil
    ) {
        self.borderOverrideColor = color
        updateColors()
    }
    
    
    
    override func awakeFromNib() {
        self.fallbackColor = fillColor
        self.borderFallbackColor = borderColor
        updateColors()
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        for trackingArea in trackingAreas {
            removeTrackingArea(trackingArea)
        }
        
        let options: NSTrackingArea.Options =
        [.mouseEnteredAndExited,
         .activeInKeyWindow]
        let trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        
        addTrackingArea(trackingArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        
        isHovered = true
        updateColors()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        
        isHovered = false
        updateColors()
    }
    
    private func updateColors() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            
            if let overrideColor {
                animator().fillColor = overrideColor
            } else {
                animator().fillColor = isHovered ? hoverColor : fallbackColor ?? hoverColor.withAlphaComponent(0)
            }
            
            if let borderOverrideColor {
                animator().borderColor = borderOverrideColor
            } else {
                animator().borderColor = isHovered ? borderHoverColor : borderFallbackColor ?? borderHoverColor.withAlphaComponent(0)
            }
        })
    }
}
