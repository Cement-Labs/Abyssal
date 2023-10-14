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
    
    private var willShow: DispatchWorkItem?
    
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
    }
    
    func update() -> Bool {
        Tips.bindViewController(popover)
        
        if isShown {
            NSAnimationContext.runAnimationGroup() { context in
                context.allowsImplicitAnimation = true
                
                popover.positioningRect = rect()
            }
        }
        
        let hasData = dataString() != nil
        let hasTip = Data.tips && (tipString() != nil)
        guard hasData || hasTip else { return false }
        
        var data: NSTextField?
        var tip: NSTextField?
        
        guard popover.contentViewController != nil else { return false }
        
        if (hasData) {
            data = Tips.createTextField(
                NSFont.systemFont(ofSize: Tips.DATA_SIZE, weight: .bold),
                dataString()!
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
                tipString()!
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
