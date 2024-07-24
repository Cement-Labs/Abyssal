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
    var sustain: CGFloat = 0.5
    var permanent: Bool = false
    
    var positionRect = { CGRect.zero }
    var positionOffset = { CGPoint.zero }
    
    var hasReactivePosition = false
    
    var title: (() -> Title)? = nil
    var content: (() -> String)? = nil
    
    private var popover: NSPopover
    private var cachedSender: NSView?
    private var lastShown: Date?
    
    private var positionUpdateTimer: Timer?
    
    private let showIdentifier = UUID()
    private var hideIdentifier = UUID()
    
    private var position: CGRect {
        positionRect().offsetBy(
            dx: positionOffset().x,
            dy: positionOffset().y
        )
    }
    
    private var timeToLastShown: TimeInterval {
        if let lastShown {
            Date.now.timeIntervalSince(lastShown)
        } else {
            0
        }
    }
    
    private var has: (title: Bool, content: Bool) {
        (
            title: title != nil,
            content: content != nil && (permanent || Defaults[.tipsEnabled])
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
        has.title || has.content || permanent
    }
    
    var isShown: Bool {
        popover.isShown
    }
    
    
    
    init(
        preferredEdge: NSRectEdge = .minX,
        delay: CGFloat = 0.5,
        sustain: CGFloat = 0.5,
        permanent: Bool = false,
        rect positionRect: (() -> CGRect)? = nil,
        offset positionOffset: (() -> CGPoint)? = nil,
        title: (() -> Title)? = nil,
        content: (() -> String)? = nil
    ) {
        self.preferredEdge = preferredEdge
        self.delay = delay
        self.sustain = sustain
        self.permanent = permanent
        
        if let positionRect {
            self.positionRect = positionRect
            self.hasReactivePosition = true
        }
        
        if let positionOffset {
            self.positionOffset = positionOffset
        }
        
        self.title = title
        self.content = content
        
        self.popover = Tip.createPopover()
    }
    
    convenience init(
        preferredEdge: NSRectEdge = .minX,
        delay: CGFloat = 0.5,
        sustain: CGFloat = 0.5,
        permanent: Bool = false,
        title: (() -> Title)? = nil,
        content: (() -> String)? = nil
    ) {
        self.init(
            preferredEdge: preferredEdge, delay: delay, sustain: sustain, permanent: permanent,
            rect: nil, offset: nil,
            title: title, content: content
        )
    }
    
    convenience init(
        preferredEdge: NSRectEdge = .minX,
        delay: CGFloat = 0.5,
        sustain: CGFloat = 0.5,
        permanent: Bool = false,
        content: (() -> String)? = nil
    ) where Title == EmptyView {
        self.init(
            preferredEdge: preferredEdge, delay: delay, sustain: sustain, permanent: permanent,
            title: nil, content: content
        )
    }
    
    private func initLayout() {
        views.vstack.subviews.removeAll()
        views.vstack.addArrangedSubview(views.title)
        views.vstack.addArrangedSubview(views.content)
        
        let view = NSView(frame: .zero)
        view.addSubview(views.vstack)
        
        view.topAnchor.constraint(equalToSystemSpacingBelow: views.vstack.topAnchor, multiplier: -0.75).isActive = true
        view.leadingAnchor.constraint(equalToSystemSpacingAfter: views.vstack.leadingAnchor, multiplier: -0.75).isActive = true
        view.bottomAnchor.constraint(equalToSystemSpacingBelow: views.vstack.bottomAnchor, multiplier: 0.75).isActive = true
        view.trailingAnchor.constraint(equalToSystemSpacingAfter: views.vstack.trailingAnchor, multiplier: 0.75).isActive = true
        
        popover.contentViewController = Tip.createViewController(view)
    }
    
    @discardableResult
    func update() -> Bool {
        guard AppDelegate.shared?.popover.isShown ?? false else {
            return false
        }
        
        if let title {
            views.title.rootView = title()
        }
        
        if let content {
            views.content.attributedStringValue = Tip.formatMarkdown(content())
        }
        
        views.title.isHidden = !has.title
        views.content.isHidden = !has.content
        
        updateFrame()
        updatePosition()
        
        return true
    }
    
    func updateFrame() {
        DispatchQueue.main.async {
            self.viewController?.view.layoutSubtreeIfNeeded()
            self.popover.contentSize = self.viewController?.view.fittingSize ?? .zero
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
        guard isAvailable else { return }
        guard isShown || (!isShown && update()) else { return }
        
        initLayout()
        
        if let sender {
            cachedSender = sender
        }
        
        guard let cachedSender else { return }
        
        DispatchQueue.main.cancel(hideIdentifier)
        DispatchQueue.main.asyncAfter(showIdentifier, deadline: .now() + delay) {
            self.lastShown = .now
            self.popover.show(
                relativeTo:     self.position,
                of:             cachedSender,
                preferredEdge:  self.preferredEdge
            )
        }
        
        if hasReactivePosition {
            positionUpdateTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 60.0,
                repeats: true
            ) { [weak self] _ in
                guard let self else { return }
                
                self.updateFrame()
                self.updatePosition()
            }
        } else {
            updateFrame()
            updatePosition()
        }
    }
    
    func hide() {
        guard isAvailable else { return }
        
        let interval = max(0, sustain - timeToLastShown)
        
        DispatchQueue.main.cancel(showIdentifier)
        DispatchQueue.main.asyncAfter(hideIdentifier, deadline: .now() + interval) {
            self.positionUpdateTimer?.invalidate()
            self.popover.performClose(self)
            
            DispatchQueue.main.asyncAfter(self.hideIdentifier, deadline: .now() + 0.2) {
                self.popover.contentViewController = nil
            }
        }
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
