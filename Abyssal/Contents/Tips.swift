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
    
    var preferredEdge: NSRectEdge
    
    var delay: CGFloat
    
    
    
    var positionRect = { NSRect.zero }
    
    var positionOffset = { NSPoint.zero }
    
    var position: NSRect {
        positionRect().offsetBy(dx: positionOffset().x, dy: positionOffset().y)
    }
    
    var positionUpdateTimer: Timer?
    
    
    
    var isShown: Bool {
        popover.isShown
    }
    
    var has: (data: Bool, tip: Bool, tipRuntime: Bool) {
        (data: dataString() != nil, tip: tipString() != nil, tipRuntime: Data.tips && tipString() != nil)
    }
    
    var lastHas: (data: Bool, tip: Bool, tipRuntime: Bool)?
    
    private var willShow: DispatchWorkItem?
    
    private var views = (data: NSTextField(), tip: NSTextField())
    
    init?(
        dataString: (() -> String?)? = nil,
        tipString: (() -> String?)? = nil,
        preferredEdge: NSRectEdge = .maxY,
        delay: CGFloat = 0.2,
        
        rect positionRect: (() -> NSRect)? = nil,
        offset positionOffset: (() -> NSPoint)? = nil
    ) {
        self.popover = Tips.createPopover()
        self.dataString = dataString ?? { nil }
        self.tipString = tipString ?? { nil }
        self.preferredEdge = preferredEdge
        self.delay = delay
        
        if let positionRect {
            self.positionRect = positionRect
        }
        
        if let positionOffset {
            self.positionOffset = positionOffset
        }
        
        // Data
        
        views.data = Tips.createTextField()
        
        // Tip
        
        views.tip = Tips.createTextField()
        views.tip.alphaValue = 0.65
    }
    
    func update() -> Bool {
        guard AppDelegate.instance?.popover.isShown ?? false else { return false }
        guard has.data || has.tipRuntime else { return false }
        
        if lastHas == nil || lastHas! != has {
            lastHas = has
            close()
            
            if has.data && has.tipRuntime {
                switchToBoth()
            } else if has.data {
                switchToOnlyData()
            } else if has.tipRuntime {
                switchToOnlyTip()
            } else { return false }
        }
        
        if has.data {
            views.data.attributedStringValue = Tips.formatData(dataString()!)
        }
        
        if has.tip {
            views.tip.attributedStringValue = Tips.formatTip(tipString()!)
        }
        
        popover.contentViewController?.view.layoutSubtreeIfNeeded()
        let size: NSSize? = popover.contentViewController?.view.frame.size
        
        if isShown {
            updatePosition()
            
            if let size {
                NSAnimationContext.runAnimationGroup() { context in
                    context.allowsImplicitAnimation = true
                    
                    self.popover.contentSize = size
                }
            }
        }
        
        return true
    }
    
    func updatePosition() {
        if isShown {
            popover.positioningRect = position
        }
    }
    
    private func switchToOnlyData() {
        let controller = Tips.createViewController()
        
        popover.contentViewController = controller
        controller.view.addSubview(views.data)
        
        Tips.addHorizontalMargins(
            parent: controller.view,
            child: views.data,
            relatedBy: .equal
        )
        Tips.addVerticalMargins(
            parent: controller.view,
            child: views.data,
            relatedBy: .equal
        )
    }
    
    private func switchToOnlyTip() {
        let controller = Tips.createViewController()
        
        popover.contentViewController = controller
        controller.view.addSubview(views.tip)
        
        Tips.addHorizontalMargins(
            parent: controller.view,
            child: views.tip,
            relatedBy: .equal
        )
        Tips.addVerticalMargins(
            parent: controller.view,
            child: views.tip,
            relatedBy: .equal
        )
    }
    
    private func switchToBoth() {
        let controller = Tips.createViewController()
        
        popover.contentViewController = controller
        controller.view.addSubview(views.data)
        controller.view.addSubview(views.tip)
        
        Tips.addHorizontalMargins(
            parent: controller.view,
            child: views.tip,
            relatedBy: .equal
        )
        controller.view.addConstraint(NSLayoutConstraint(
            item: controller.view,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: views.data,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        ))
        
        controller.view.addConstraint(NSLayoutConstraint(
            item: controller.view,
            attribute: .top,
            relatedBy: .equal,
            toItem: views.data,
            attribute: .top,
            multiplier: 1,
            constant: -Tips.MARGIN.height
        ))
        controller.view.addConstraint(NSLayoutConstraint(
            item: views.data,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: views.tip,
            attribute: .top,
            multiplier: 1,
            constant: -Tips.MARGIN.height
        ))
        controller.view.addConstraint(NSLayoutConstraint(
            item: controller.view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: views.tip,
            attribute: .bottom,
            multiplier: 1,
            constant: Tips.MARGIN.height
        ))
    }
    
    func show(
        _ sender: NSView
    ) {
        guard isShown || (!isShown && update()) else { return }
        
        willShow = DispatchWorkItem {
            self.popover.show(
                relativeTo:     self.position,
                of:             sender,
                preferredEdge:  self.preferredEdge
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: willShow!)
        
        positionUpdateTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0 / 60.0,
            repeats: true
        ) { [weak self] _ in
            guard let self else { return }
            
            self.updatePosition()
        }
    }
    
    func close() {
        positionUpdateTimer?.invalidate()
        willShow?.cancel()
        popover.performClose(self)
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
    
    static let DATA_SIZE: CGFloat = 14.5
    
    static let TIP_SIZE: CGFloat = 10
    
    static let MARGIN: (width: CGFloat, height: CGFloat) = (width: 16, height: 12)
    
    static let MAX_WIDTH: CGFloat = 300
    
}

extension Tips {
    
    static func generateMarkdown(
        _ text: String,
        font: NSFont,
        alignment: NSTextAlignment = .natural
    ) -> NSMutableAttributedString {
        let markdown = try! NSAttributedString.init(
            markdown: text.data(using: .utf8)!,
            options: .init(
                allowsExtendedAttributes: true,
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        ) as! NSMutableAttributedString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.allowsDefaultTighteningForTruncation = true
        paragraphStyle.paragraphSpacing = font.pointSize * 0.4
        
        markdown.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: markdown.length)
        )
        
        markdown.addAttribute(
            .font,
            value: font,
            range: NSRange(location: 0, length: markdown.length)
        )
        
        return markdown
    }
    
    static func formatData(
        _ text: String
    ) -> NSAttributedString {
        return generateMarkdown(
            text,
            font: NSFont.boldSystemFont(ofSize: DATA_SIZE),
            alignment: .center
        )
    }
    
    static func formatTip(
        _ text: String
    ) -> NSAttributedString {
        return generateMarkdown(
            text,
            font: NSFont.systemFont(ofSize: TIP_SIZE)
        )
    }
    
}

extension Tips {
    
    static func createPopover() -> NSPopover {
        let popover = NSPopover()
        
        popover.behavior = .applicationDefined
        popover.animates = true
        
        return popover
    }
    
    static func createViewController() -> NSViewController {
        let controller = NSViewController()
        controller.view = NSView()
        
        return controller
    }
    
    static func createTextField() -> NSTextField {
        let textField = NSTextField(frame: NSRect.zero)
        textField.cell?.truncatesLastVisibleLine = false
        
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBezeled = false
        textField.drawsBackground = false
    
        textField.lineBreakMode = .byWordWrapping
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
