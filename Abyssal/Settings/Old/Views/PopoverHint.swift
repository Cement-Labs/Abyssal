//
//  PopoverHint.swift
//  Abyssal
//
//  Created by KrLite on 2024/7/3.
//

import SwiftUI

struct PopoverHint<Content>: View where Content: View {
    @State var sustain: TimeInterval = 0.5
    @State var arrowEdge: Edge = .top
    @ViewBuilder var content: () -> Content
    
    @State private var isPopoverPresented: Bool = false
    @State private var dispatch: DispatchWorkItem?
    @State private var lastShown: Date?
    
    private var timeToLastShown: TimeInterval {
        if let lastShown {
            Date.now.timeIntervalSince(lastShown)
        } else {
            0
        }
    }
    
    var body: some View {
        VStack {
            Circle()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 6)
                .foregroundStyle(.tint)
            
            Spacer()
        }
        .padding(1)
        .onHover { isHovering in
            if isHovering {
                // Open
                dispatch?.cancel()
                dispatch = nil
                
                lastShown = .now
                isPopoverPresented = true
            } else {
                // Schedule close
                dispatch = .init {
                    self.isPopoverPresented = false
                }
                
                let interval = max(0, sustain - timeToLastShown)
                DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: dispatch!)
            }
        }
        .popover(isPresented: $isPopoverPresented, arrowEdge: arrowEdge) {
            content()
        }
    }
}
