//
//  Tips.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

class Tips {
    
    class Tip {
        
        var popover: NSPopover
        
        var dataString: String? = nil
        
        var tipString: String? = nil
        
        var isShown: Bool {
            popover.isShown
        }
        
        init?(
            dataString: String? = nil,
            tipString: String? = nil
        ) {
            self.popover = Tips.createPopover()
            self.dataString = dataString
            self.tipString = tipString
        }
        
        func update() {
            Tips.bindViewController(popover)
            
            let hasData = dataString != nil
            let hasTip = Data.tips && tipString != nil
            guard hasData || hasTip else { return }
            
            var data: NSTextField?
            var tip: NSTextField?
            
            guard popover.contentViewController != nil else { return }
            
            if (hasData) {
                data = Tips.createTextField(
                    NSFont.systemFont(ofSize: Tips.DATA_SIZE, weight: .bold),
                    dataString!
                )
                data?.alignment = .center
                
                popover.contentViewController!.view.addSubview(data!)
                
                Tips.addHorizontalMargins(
                    parent: popover.contentViewController!.view,
                    child: data,
                    relatedBy: .equal
                )
                
                if (!hasTip) {
                    Tips.addVerticalMargins(
                        parent: popover.contentViewController!.view,
                        child: data,
                        relatedBy: .equal
                    )
                }
            }
            
            if (hasTip) {
                tip = Tips.createTextField(
                    NSFont.systemFont(ofSize: Tips.TIP_SIZE, weight: .regular),
                    tipString!
                )
                tip?.alphaValue = 0.65
                
                popover.contentViewController?.view.addSubview(tip!)
                
                Tips.addHorizontalMargins(
                    parent: popover.contentViewController!.view,
                    child: tip,
                    relatedBy: .equal
                )
                
                if (!hasData) {
                    Tips.addVerticalMargins(
                        parent: popover.contentViewController!.view,
                        child: tip,
                        relatedBy: .equal
                    )
                }
            }
            
            if (hasData && hasTip) {
                popover.contentViewController!.view.addConstraint(NSLayoutConstraint(
                    item: popover.contentViewController!.view,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: data,
                    attribute: .top,
                    multiplier: 1,
                    constant: -Tips.MARGIN.height
                ))
                popover.contentViewController!.view.addConstraint(NSLayoutConstraint(
                    item: data!,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: tip,
                    attribute: .top,
                    multiplier: 1,
                    constant: -Tips.MARGIN.height
                ))
                popover.contentViewController!.view.addConstraint(NSLayoutConstraint(
                    item: popover.contentViewController!.view,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: tip,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: Tips.MARGIN.height
                ))
            }
        }
        
        func show(
            _ sender: NSView,
            _ rect: NSRect? = nil
        ) {
            update()
            
            popover.show(
                relativeTo:     rect ?? sender.bounds,
                of:             sender,
                preferredEdge:  NSRectEdge.maxY
            )
        }
        
        func reposition(
            _ rect: NSRect
        ) {
            popover.positioningRect = rect
        }
        
        func transform(
            _ transform: CGAffineTransform
        ) {
            reposition(popover.positioningRect.applying(transform))
        }
        
        func close() {
            popover.performClose(self)
        }
        
    }
    
}

extension Tips {
    
    public static let DATA_SIZE: CGFloat = 14.5
    
    public static let TIP_SIZE: CGFloat = 10
    
    public static let MARGIN: (width: CGFloat, height: CGFloat) = (width: 16, height: 12)
    
    public static let MAX_WIDTH: CGFloat = 350
    
}

extension Tips {
    
    static func createPopover() -> NSPopover {
        let popover = NSPopover()
        
        popover.behavior = .applicationDefined
        popover.animates = true
        
        return popover
    }
    
    static func bindViewController(
        _ popover: NSPopover
    ) {
        let controller = NSViewController()
        controller.view = NSView()
        
        popover.contentViewController = controller
    }
    
    static func createTextField(
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
    
    static func addHorizontalMargins(
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
    
    static func addVerticalMargins(
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
