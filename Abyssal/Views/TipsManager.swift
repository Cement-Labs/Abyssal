//
//  TipsManager.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

class Tips {
    
    static let test: NSPopover = NSPopover()
    
}

extension MenuController {
    
    func showLittlePopoverWithMessage(
        sender: NSView, message: String
    ) {
        let controller = NSViewController()
        controller.view = NSView(frame: NSRect.zero)

        let popover = NSPopover()
        popover.contentViewController = controller
        popover.contentSize = controller.view.frame.size

        popover.behavior = .transient
        popover.animates = true

        let txt = NSTextField(frame: NSRect.zero)
        txt.cell = MarginTextFieldCell()
        
        txt.stringValue = message
        txt.isEditable = false
        txt.isSelectable = false
        txt.isBezeled = false
        txt.drawsBackground = false
        txt.font = NSFont.systemFont(ofSize: 17.5, weight: .bold)
        txt.sizeToFit()
        
        controller.view.addSubview(txt)
        
        controller.view.addConstraint(NSLayoutConstraint(item: txt, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0))
        controller.view.addConstraint(NSLayoutConstraint(item: txt, attribute: .centerY, relatedBy: .equal, toItem: controller.view, attribute: .centerY, multiplier: 1, constant: 0))
        
        popover.show(
            relativeTo: sender.bounds,
            of: sender,
            preferredEdge: NSRectEdge.maxY
        )
    }
    
}
