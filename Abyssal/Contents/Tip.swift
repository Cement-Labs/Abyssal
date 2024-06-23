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
    
    private var popover: NSPopover
    
    private var position: CGRect {
        positionRect().offsetBy(
            dx: positionOffset().x,
            dy: positionOffset().y
        )
    }
    
    private var hasReactivePosition = false
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
        content: @escaping () -> Content
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
    }
    
    private func update() -> Bool {
        guard AppDelegate.shared?.popover.isShown ?? false else {
            return false
        }
        
        updatePosition()
        
        return true
    }
    
    private func updatePosition() {
        if isShown {
            popover.positioningRect = position
        }
    }
    
    func show(_ sender: NSView) {
        guard isShown || (!isShown && update()) else {
            return
        }
        
        showDispatch = .init {
            self.popover.show(
                relativeTo:     self.position,
                of:             sender,
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
                
                self.updatePosition()
            }
        } else {
            self.updatePosition()
        }
    }
    
    func hide() {
        positionUpdateTimer?.invalidate()
        
        showDispatch?.cancel()
        showDispatch = nil
        
        popover.performClose(self)
    }
    
    func toggle(_ sender: NSView, show: Bool) {
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
