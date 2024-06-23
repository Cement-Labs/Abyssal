//
//  Tip.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import Foundation
import AppKit
import SwiftUI

class Tip<Content> where Content: View {
    var content: () -> Content
    var preferredEdge: NSRectEdge = .minY
    var delay: CGFloat = 0.5
    
    var positionRect = { CGRect.zero }
    var positionOffset = { CGPoint.zero }
    
    var hasReactivePosition = false
    
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
    
    
    
    var isShown: Bool {
        popover.isShown
    }
    
    init(
        preferredEdge: NSRectEdge = .minY,
        delay: CGFloat = 0.5,
        rect positionRect: (() -> CGRect)? = nil,
        offset positionOffset: (() -> CGPoint)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.preferredEdge = preferredEdge
        self.delay = delay
        
        if let positionRect {
            self.positionRect = positionRect
            self.hasReactivePosition = true
        }
        
        if let positionOffset {
            self.positionOffset = positionOffset
        }
        
        self.popover = Self.createPopover()
        self.popover.contentViewController = Self.createViewController(content: content)
        
        updateFrame()
    }
    
    func update() -> Bool {
        guard AppDelegate.shared?.popover.isShown ?? false else {
            return false
        }
        
        self.updatePosition()
        self.updateFrame()
        
        return true
    }
    
    func updatePosition() {
        if isShown {
            DispatchQueue.main.async {
                self.popover.positioningRect = self.position
            }
        }
    }
    
    func updateFrame() {
        self.popover.contentSize = self.popover.contentViewController?.view.fittingSize ?? .zero
    }
    
    func cache(_ sender: NSView?) {
        cachedSender = sender
    }
    
    func show(_ sender: NSView?) {
        guard isShown || (!isShown && update()) else { return }
        
        if let sender {
            cachedSender = sender
        }
        
        guard let cachedSender else { return }
        
        showDispatch = .init {
            self.popover.show(
                relativeTo:     self.position,
                of:             cachedSender,
                preferredEdge:  self.preferredEdge
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: showDispatch!)
        
        if self.hasReactivePosition {
            self.positionUpdateTimer = Timer.scheduledTimer(
                withTimeInterval: 1.0 / 60.0,
                repeats: true
            ) { [weak self] _ in
                guard let self else { return }
                
                self.updatePosition()
                self.updateFrame()
            }
        } else {
            self.updatePosition()
            self.updateFrame()
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
    static func createPopover() -> NSPopover {
        let popover = NSPopover()
        
        popover.behavior = .applicationDefined
        popover.animates = true
        
        return popover
    }
    
    static func createViewController(
        @ViewBuilder content: () -> Content
    ) -> NSViewController {
        let controller = NSHostingController(rootView: content())
        
        return controller
    }
}
