//
//  TipWrapper.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI
import Defaults

struct TipWrapper<Content, TipContent, Value>: View
where Content: View, TipContent: View, Value: Equatable {
    typealias Tip = Abyssal.Tip<TipContent>
    
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
            .onHover { isHovering in
                self.isHovering = isHovering
                
                if (alwaysVisible || tipsEnabled) {
                    tip.toggle(show: isHovering)
                }
            }
            .onChange(of: value) { _, _ in
                tip.updatePosition()
            }
    }
}
