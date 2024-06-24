//
//  TipWrapper.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI
import Defaults
import SwiftUIIntrospect

struct TipWrapper<Content, Value>: View
where Content: View, Value: Equatable {
    @Default(.tipsEnabled) private var tipsEnabled
    
    var alwaysVisible: Bool = false
    @Binding var value: Value
    var tip: Tip
    @ViewBuilder var content: (Tip) -> Content
    
    @State private var isHovering: Bool = false
    
    init(
        alwaysVisible: Bool = false,
        value: Binding<Value>,
        tip: Tip,
        @ViewBuilder content: @escaping (Tip) -> Content
    ) {
        self.alwaysVisible = alwaysVisible
        self._value = value
        self.tip = tip
        self.content = content
    }
    
    init(
        alwaysVisible: Bool = false,
        tip: Tip,
        @ViewBuilder content: @escaping (Tip) -> Content
    ) where Value == Bool {
        self.init(alwaysVisible: alwaysVisible, value: .constant(false), tip: tip, content: content)
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
            .introspect(.picker(style: .menu), on: .macOS(.v14, .v15)) { picker in
                tip.cache(picker)
            }
            .introspect(.toggle(style: .switch), on: .macOS(.v14, .v15)) { toggle in
                tip.cache(toggle)
            }
            .introspect(.view, on: .macOS(.v14, .v15)) { view in
                tip.cache(view)
            }
    }
}
