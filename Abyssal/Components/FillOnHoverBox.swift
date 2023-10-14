//
//  FillOnHoverBox.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

class FillOnHoverBox: NSBox {
    
    private var originalFillColor: NSColor = NSColor.clear
    
    private var overrideFillColor: NSColor?
    
    private var isHovered: Bool = false
    
    public func setOriginlalFillColor(
        _ originalFillColor: NSColor
    ) {
        self.originalFillColor = originalFillColor
    }
    
    public func overrideFillColor(
        _ overrideFillColor: NSColor? = nil
    ) {
        self.overrideFillColor = overrideFillColor
        updateFillColor()
    }
    
    override func awakeFromNib() {
        updateFillColor()
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
        updateFillColor()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        
        isHovered = false
        updateFillColor()
    }
    
    private func updateFillColor() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            
            if overrideFillColor == nil {
                animator().fillColor = isHovered ? originalFillColor : originalFillColor.withAlphaComponent(0)
            } else {
                animator().fillColor = overrideFillColor!
            }
        })
    }
    
}
