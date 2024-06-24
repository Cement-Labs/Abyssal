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

class Tip {
    static var margin: CGSize = .init(width: 20, height: 20)
    
    var preferredEdge: NSRectEdge = .minX
    var delay: CGFloat = 0.5
    
    var positionRect = { CGRect.zero }
    var positionOffset = { CGPoint.zero }
    
    var hasReactivePosition = false
    
    var title: (() -> String)? = nil
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
    
    
    
    private var views = (vstack: Tip.createStackView(), title: Tip.createTextField(), content: Tip.createTextField())
    
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
        title: (() -> String)? = nil,
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
        
        self.popover = Tip.createPopover()
        self.popover.contentViewController = Tip.createViewController(self.views.vstack)
        
        self.title = title
        self.content = content
    }
    
    convenience init(
        preferredEdge: NSRectEdge = .minX,
        delay: CGFloat = 0.5,
        title: (() -> String)? = nil,
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
    ) {
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
            views.title.attributedStringValue = Tip.formatTitle(title())
        }
        views.title.isHidden = !has.title
        
        if let content {
            views.content.attributedStringValue = Tip.formatContent(content())
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
                
                self.updateFrame()
                self.updatePosition()
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
        stackView.edgeInsets = .init(top: margin.height, left: margin.width, bottom: margin.height, right: margin.width)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
}

extension Tip {
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
    
    static func formatTitle(
        _ text: String
    ) -> NSAttributedString {
        generateMarkdown(text, font: NSFont.boldSystemFont(ofSize: 20), alignment: .center)
    }
    
    static func formatContent(
        _ text: String
    ) -> NSAttributedString {
        generateMarkdown(text, font: NSFont.systemFont(ofSize: 11))
    }
}
