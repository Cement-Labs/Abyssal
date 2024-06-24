//
//  Tip.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import Foundation
import AppKit
import SwiftUI
import Defaults
import SwiftUIIntrospect

class Tip<Title> where Title: View {
    var preferredEdge: NSRectEdge = .minX
    var delay: CGFloat = 0.5
    
    var positionRect = { CGRect.zero }
    var positionOffset = { CGPoint.zero }
    
    var hasReactivePosition = false
    
    var title: (() -> Title)? = nil
    var content: (() -> String)? = nil
    
    private var popover: NSPopover
    private var cachedSender: NSView?
    
    private var position: CGRect {
        positionRect().offsetBy(
            dx: positionOffset().x,
            dy: positionOffset().y
        )
    }
    
    private var positionUpdateTimer: Timer?
    
    private var showDispatch: DispatchWorkItem?
    
    private var has: (title: Bool, content: Bool) {
        (
            title: title != nil,
            content: content != nil && Defaults[.tipsEnabled]
        )
    }
    
    
    
    private var views: (vstack: NSStackView, title: NSHostingView<Title?>, content: NSTextField) = (
        vstack: Tip.createStackView(),
        title: .init(rootView: nil),
        content: Tip.createTextField()
    )
    
    private var viewController: NSViewController? {
        popover.contentViewController
    }
    
    
    
    var isAvailable: Bool {
        has.title || has.content
    }
    
    var isShown: Bool {
        popover.isShown
    }
    
    init(
        preferredEdge: NSRectEdge = .minX,
        delay: CGFloat = 0.5,
        rect positionRect: (() -> CGRect)? = nil,
        offset positionOffset: (() -> CGPoint)? = nil,
        title: (() -> Title)? = nil,
        content: (() -> String)? = nil
    ) {
        self.preferredEdge = preferredEdge
        self.delay = delay
        
        if let positionRect {
            self.positionRect = positionRect
            self.hasReactivePosition = true
        }
        
        if let positionOffset {
            self.positionOffset = positionOffset
        }
        
        self.views.vstack.addArrangedSubview(self.views.title)
        self.views.vstack.addArrangedSubview(self.views.content)
        
        Tip.addHorizontalMargins(parent: self.views.vstack, child: self.views.content, relatedBy: .equal)
        
        self.popover = Tip.createPopover()
        self.popover.contentViewController = Tip.createViewController(self.views.vstack)
        
        self.title = title
        self.content = content
    }
    
    convenience init(
        preferredEdge: NSRectEdge = .minX,
        delay: CGFloat = 0.5,
        title: (() -> Title)? = nil,
        content: (() -> String)? = nil
    ) {
        self.init(
            preferredEdge: preferredEdge, delay: delay,
            rect: nil, offset: nil,
            title: title, content: content
        )
    }
    
    convenience init(
        preferredEdge: NSRectEdge = .minX,
        delay: CGFloat = 0.5,
        content: (() -> String)? = nil
    ) where Title == EmptyView {
        self.init(
            preferredEdge: preferredEdge, delay: delay,
            title: nil, content: content
        )
    }
    
    @discardableResult
    func update() -> Bool {
        guard AppDelegate.shared?.popover.isShown ?? false else {
            return false
        }
        
        if let title {
            views.title.rootView = title()
        }
        views.title.isHidden = !has.title
        
        if let content {
            views.content.attributedStringValue = Tip.formatMarkdown(content())
        }
        views.content.isHidden = !has.content
        
        updateFrame()
        updatePosition()
        
        return true
    }
    
    func updateFrame() {
        DispatchQueue.main.async {
            self.views.vstack.layoutSubtreeIfNeeded()
            self.popover.contentSize = self.views.vstack.fittingSize
        }
    }
    
    func updatePosition() {
        if isShown {
            DispatchQueue.main.async {
                self.popover.positioningRect = self.position
            }
        }
    }
    
    func cache(_ sender: NSView?) {
        cachedSender = sender
    }
    
    func show(_ sender: NSView?) {
        guard isShown || (!isShown && update()) else { return }
        guard isAvailable else { return }
        
        if let sender {
            cachedSender = sender
        }
        
        guard let cachedSender else { return }
        
        showDispatch = .init {
            self.updateFrame()
            self.updatePosition()
            
            self.popover.show(
                relativeTo:     self.position,
                of:             cachedSender,
                preferredEdge:  self.preferredEdge
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: showDispatch!)
        
        if hasReactivePosition {
            positionUpdateTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 60.0,
                repeats: true
            ) { [weak self] _ in
                guard let self else { return }
                
                self.update()
            }
        }
    }
    
    func hide() {
        positionUpdateTimer?.invalidate()
        
        showDispatch?.cancel()
        showDispatch = nil
        
        popover.performClose(self)
    }
    
    func toggle(_ sender: NSView? = nil, show: Bool) {
        if show {
            self.show(sender)
        } else {
            hide()
        }
    }
}

extension Tip {
    
}

extension Tip {
    static func createPopover() -> NSPopover {
        let popover = NSPopover()
        
        popover.behavior = .applicationDefined
        popover.animates = true
        
        return popover
    }
    
    static func createViewController(_ view: NSView) -> NSViewController {
        let controller = NSViewController()
        
        controller.view = view
        
        return controller
    }
    
    static func createTextField() -> NSTextField {
        let textField = NSTextField(frame: .zero)
        
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBezeled = false
        textField.drawsBackground = false
        
        textField.cell?.truncatesLastVisibleLine = false
        textField.lineBreakMode = .byWordWrapping
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        
        return textField
    }
    
    static func createStackView() -> NSStackView {
        let stackView = NSStackView(frame: .zero)
        
        stackView.orientation = .vertical
        stackView.spacing = 8
        stackView.edgeInsets = .init(top: 20, left: 0, bottom: 20, right: 0)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
}

extension Tip {
    static func formatMarkdown(
        _ text: String,
        font: NSFont = .systemFont(ofSize: NSFont.systemFontSize),
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
}

extension Tip {
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
            constant: -20
        ))
        parent.addConstraint(NSLayoutConstraint(
            item: parent,
            attribute: .trailing,
            relatedBy: relatedBy,
            toItem: child,
            attribute: .trailing,
            multiplier: 1,
            constant: 20
        ))
    }
}
