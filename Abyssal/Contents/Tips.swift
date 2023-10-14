//
//  Tips.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

class Tip {
    
    var popover: NSPopover
    
    var dataString: () -> String?
    
    var tipString: () -> String?
    
    var rect: () -> NSRect = { NSRect.zero }
    
    var isShown: Bool {
        popover.isShown
    }
    
    var has: (data: Bool, tip: Bool, tipRuntime: Bool) {
        (data: dataString() != nil, tip: tipString() != nil, tipRuntime: Data.tips && self.has.tip)
    }
    
    private var willShow: DispatchWorkItem?
    
    private var views = (data: NSTextField(), tip: NSTextField())
    
    private var controllers = (onlyData: NSViewController(), onlyTip: NSViewController(), both: NSViewController())
    
    init?(
        dataString: (() -> String?)? = nil,
        tipString: (() -> String?)? = nil,
        rect: (() -> NSRect)? = nil
    ) {
        self.popover = Tips.createPopover()
        self.dataString = dataString ?? { nil }
        self.tipString = tipString ?? { nil }
        if (rect != nil) {
            self.rect = rect!
        }
        
        do {
            // Data
            
            views.data = Tips.createTextField(
                NSFont.systemFont(ofSize: Tips.DATA_SIZE, weight: .bold),
                ""
            )
            views.data.alignment = .center
            controllers.onlyData.view.addSubview(views.data)
            controllers.both.view.addSubview(views.data)
            
            Tips.addHorizontalMargins(
                parent: controllers.onlyData.view,
                child: views.data,
                relatedBy: .equal
            )
            Tips.addHorizontalMargins(
                parent: controllers.both.view,
                child: views.data,
                relatedBy: .equal
            )
            
            Tips.addVerticalMargins(
                parent: controllers.onlyData.view,
                child: views.data,
                relatedBy: .equal
            )
        }
            
        do {
            // Tip
            
            views.tip = Tips.createTextField(
                NSFont.systemFont(ofSize: Tips.TIP_SIZE, weight: .regular),
                ""
            )
            views.tip.alphaValue = 0.65
            controllers.onlyTip.view.addSubview(views.tip)
            controllers.both.view.addSubview(views.tip)
            
            Tips.addHorizontalMargins(
                parent: controllers.onlyTip.view,
                child: views.tip,
                relatedBy: .equal
            )
            Tips.addHorizontalMargins(
                parent: controllers.both.view,
                child: views.tip,
                relatedBy: .equal
            )
            
            Tips.addVerticalMargins(
                parent: controllers.onlyTip.view,
                child: views.tip,
                relatedBy: .equal
            )
        }
        
        do {
            // Both
            
            controllers.both.view.addConstraint(NSLayoutConstraint(
                item: controllers.both.view,
                attribute: .top,
                relatedBy: .equal,
                toItem: views.data,
                attribute: .top,
                multiplier: 1,
                constant: -Tips.MARGIN.height
            ))
            controllers.both.view.addConstraint(NSLayoutConstraint(
                item: views.data,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: views.tip,
                attribute: .top,
                multiplier: 1,
                constant: -Tips.MARGIN.height
            ))
            controllers.both.view.addConstraint(NSLayoutConstraint(
                item: controllers.both.view,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: views.tip,
                attribute: .bottom,
                multiplier: 1,
                constant: Tips.MARGIN.height
            ))
        }
    }
    
    func update() -> Bool {
        guard has.data || has.tipRuntime else { return false }
        
        if isShown {
            NSAnimationContext.runAnimationGroup() { context in
                context.allowsImplicitAnimation = true
                
                popover.positioningRect = rect()
            }
        }
        
        if has.data {
            views.data.stringValue = dataString()!
        }
        
        if has.tip {
            views.tip.stringValue = tipString()!
        }
        
        if has.data && has.tipRuntime {
            popover.contentViewController = controllers.both
        } else if has.data {
            popover.contentViewController = controllers.onlyData
        } else if has.tipRuntime {
            popover.contentViewController = controllers.onlyTip
        } else {
            popover.contentViewController = nil
            return false
        }
        
        popover.contentViewController?.updateViewConstraints()
        
        return true
    }
    
    func show(
        _ sender: NSView
    ) {
        guard isShown || (!isShown && update()) else { return }
        
        willShow = DispatchWorkItem {
            self.popover.show(
                relativeTo:     self.rect(),
                of:             sender,
                preferredEdge:  NSRectEdge.maxY
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: willShow!)
    }
    
    func close() {
        willShow?.cancel()
        popover.performClose(self)
    }
    
    func offset(
        _ dx: CGFloat,
        _ dy: CGFloat
    ) {
        rect = { self.rect().offsetBy(dx: dx, dy: dy) }
    }
    
}

class Tips {
    
    static let test = Tip(
        dataString: { "Lorem Ipsum" },
        tipString: { "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." }
    )
    
    static let testData = Tip(
        dataString: test?.dataString
    )
    
    static let testTip = Tip(
        tipString: test?.tipString
    )
    
    
    
    private var map: [NSTrackingArea: (tip: Tip, sender: NSView)] = [:]
    
    func mouseEntered(with event: NSEvent) {
        if let area = event.trackingArea {
            map
                .filter { $0.key == area }
                .forEach { $0.value.tip.show($0.value.sender) }
        }
    }
    
    func mouseExited(with event: NSEvent) {
        if let area = event.trackingArea {
            map
                .filter { $0.key == area }
                .forEach { $0.value.tip.close() }
        }
    }
    
    func bind(
        _ sender: NSView,
        trackingArea: NSTrackingArea,
        tip: Tip
    ) {
        map[trackingArea] = (tip, sender)
    }
    
    func unbind(
        trackingArea: NSTrackingArea
    ) -> (tip: Tip, sender: NSView)? {
        map.removeValue(forKey: trackingArea)
    }
    
}

extension Tips {
    
    public static let DATA_SIZE: CGFloat = 14.5
    
    public static let TIP_SIZE: CGFloat = 10
    
    public static let MARGIN: (width: CGFloat, height: CGFloat) = (width: 16, height: 12)
    
    public static let MAX_WIDTH: CGFloat = 300
    
}

extension Tips {
    
    static func createPopover() -> NSPopover {
        let popover = NSPopover()
        
        popover.behavior = .applicationDefined
        popover.animates = true
        
        return popover
    }
    
    static func createViewController(
        _ popover: NSPopover
    ) -> NSViewController {
        let controller = NSViewController()
        controller.view = NSView()
        
        return controller
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
