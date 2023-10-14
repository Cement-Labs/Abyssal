//
//  Tips.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

class Tips {
    
    public static let DATA_SIZE: CGFloat = 17.5
    
    public static let TIP_SIZE: CGFloat = 12
    
    public static let MARGIN: (width: CGFloat, height: CGFloat) = (width: 20, height: 16)
    
    public static let MAX_WIDTH: CGFloat = 350
    
}

extension Tips {
    
    private static func createPopover() -> (controller: NSViewController, popover: NSPopover) {
        let controller = NSViewController()
        controller.view = NSView(frame: NSRect.zero)
        
        let popover = NSPopover()
        popover.contentViewController = controller
        popover.contentSize = controller.view.frame.size
        
        popover.behavior = .semitransient
        popover.animates = true
        
        return (controller, popover)
    }
    
    private static func createTextField(
        _ font: NSFont,
        _ message: String
    ) -> NSTextField {
        let textField = NSTextField(frame: NSRect.zero)
        textField.cell?.truncatesLastVisibleLine = false
        
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBezeled = false
        textField.drawsBackground = false
        
        textField.stringValue = message
        textField.font = font
        textField.lineBreakMode = .byWordWrapping
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.sizeToFit()
        
        textField.widthAnchor.constraint(lessThanOrEqualToConstant: MAX_WIDTH).isActive = true
        
        return textField
    }
    
}

extension Tips {
    
    private static func addHorizontalMargins(
        parent: NSView,
        child: NSView?,
        relatedBy: NSLayoutConstraint.Relation
    ) {
        parent.addConstraint(NSLayoutConstraint(
            item: parent,
            attribute: .leading,
            relatedBy: relatedBy,
            toItem: child,
            attribute: .leading,
            multiplier: 1,
            constant: -MARGIN.width
        ))
        parent.addConstraint(NSLayoutConstraint(
            item: parent,
            attribute: .trailing,
            relatedBy: relatedBy,
            toItem: child,
            attribute: .trailing,
            multiplier: 1,
            constant: MARGIN.width
        ))
    }
    
    private static func addVerticalMargins(
        parent: NSView,
        child: NSView?,
        relatedBy: NSLayoutConstraint.Relation
    ) {
        parent.addConstraint(NSLayoutConstraint(
            item: parent,
            attribute: .top,
            relatedBy: relatedBy,
            toItem: child,
            attribute: .top,
            multiplier: 1,
            constant: -MARGIN.height
        ))
        parent.addConstraint(NSLayoutConstraint(
            item: parent,
            attribute: .bottom,
            relatedBy: relatedBy,
            toItem: child,
            attribute: .bottom,
            multiplier: 1,
            constant: MARGIN.height
        ))
    }
    
}

extension Tips {
    
    static func show(
        _ sender: NSView,
        _ rect: NSRect? = nil,
        dataString: String? = nil,
        tipString: String? = nil
    ) {
        let hasData = dataString != nil
        let hasTip = Data.tips && tipString != nil
        guard hasData || hasTip else { return }
        
        let p = createPopover()
        var data: NSTextField?
        var tip: NSTextField?
        
        if (hasData) {
            data = createTextField(
                NSFont.systemFont(ofSize: DATA_SIZE, weight: .bold),
                dataString!
            )
            data?.alignment = .center
            
            p.controller.view.addSubview(data!)
            
            addHorizontalMargins(
                parent: p.controller.view,
                child: data,
                relatedBy: .equal
            )
            
            if (!hasTip) {
                addVerticalMargins(
                    parent: p.controller.view,
                    child: data,
                    relatedBy: .equal
                )
            }
        }
        
        if (hasTip) {
            tip = createTextField(
                NSFont.systemFont(ofSize: TIP_SIZE, weight: .regular),
                tipString!
            )
            tip?.alphaValue = 0.65
            
            p.controller.view.addSubview(tip!)
            
            addHorizontalMargins(
                parent: p.controller.view,
                child: tip,
                relatedBy: .equal
            )
            
            if (!hasData) {
                addVerticalMargins(
                    parent: p.controller.view,
                    child: tip,
                    relatedBy: .equal
                )
            }
        }
        
        if (hasData && hasTip) {
            p.controller.view.addConstraint(NSLayoutConstraint(
                item: p.controller.view,
                attribute: .top,
                relatedBy: .equal,
                toItem: data,
                attribute: .top,
                multiplier: 1,
                constant: -MARGIN.height
            ))
            p.controller.view.addConstraint(NSLayoutConstraint(
                item: data!,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: tip,
                attribute: .top,
                multiplier: 1,
                constant: -MARGIN.height
            ))
            p.controller.view.addConstraint(NSLayoutConstraint(
                item: p.controller.view,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: tip,
                attribute: .bottom,
                multiplier: 1,
                constant: MARGIN.height
            ))
        }
        
        p.popover.show(
            relativeTo:     rect ?? sender.bounds,
            of:             sender,
            preferredEdge:  NSRectEdge.maxY
        )
    }
    
}
