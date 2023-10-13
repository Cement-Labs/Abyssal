//
//  HighlightBorderOnHoverView.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

class FillOnHoverBox: NSBox {
    
    private var fill: CGColor?
    
    private var onHover: Bool = false
    
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
        
        onHover = true
        a()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        
        onHover = false
        a()
    }
    
    private func a() {
        animator().layer?.backgroundColor = onHover ? NSColor.white.cgColor : NSColor.black.cgColor
        layer?.setNeedsDisplay()
    }
    
}
