//
//  TipWrapper.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI
import Defaults
import SwiftUIIntrospect

struct TipWrapper<Content, Title, Value>: View
where Content: View, Title: View, Value: Equatable {
    typealias Tip = Abyssal.Tip<Title>
    
    @Default(.tipsEnabled) private var tipsEnabled
    
    var tip: Tip
    var alwaysVisible: Bool = false
    @Binding var value: Value
    @ViewBuilder var content: (Tip) -> Content
    
    @State private var isHovering: Bool = false
    
    init(
        tip: Tip,
        alwaysVisible: Bool = false,
        value: Binding<Value>,
        @ViewBuilder content: @escaping (Tip) -> Content
    ) {
        self.tip = tip
        self.alwaysVisible = alwaysVisible
        self._value = value
        self.content = content
    }
    
    init(
        tip: Tip,
        alwaysVisible: Bool = false,
        @ViewBuilder content: @escaping (Tip) -> Content
    ) where Value == Bool {
        self.init(tip: tip, alwaysVisible: alwaysVisible, value: .constant(false), content: content)
    }
    
    var body: some View {
        content(tip)
        // Show on hover
            .onHover { isHovering in
                self.isHovering = isHovering
                
                if (alwaysVisible || tipsEnabled) {
                    tip.toggle(show: isHovering)
                }
            }
        
        // Update when value changes
            .onChange(of: value) { _, _ in
                tip.updateFrame()
                tip.updatePosition()
            }
        
        // Cache view
            .introspect(.slider, on: .macOS(.v14, .v15)) { slider in
                tip.cache(slider)
                
                tip.positionRect = {
                    slider.knobRect
                }
                tip.hasReactivePosition = true
            }
            .introspect(.view, on: .macOS(.v14, .v15)) { view in
                tip.cache(view)
            }
    }
}
