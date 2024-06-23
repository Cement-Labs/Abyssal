//
//  Box.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI

struct Box<Content>: View
where Content: View {
    enum Behavior {
        case button
        case toggle
    }
    
    @Binding var isOn: Bool
    
    @ViewBuilder var content: () -> Content
    
    @State private var isHovering: Bool = false
    
    @Namespace var colorTransition
    
    var cornerSize: CGSize = .init(width: 8, height: 8)
    var behavior: Behavior = .button
    var action: () -> Void = {}
    
    init(
        isOn: Bool,
        cornerSize: CGSize = .init(width: 8, height: 8),
        behavior: Behavior = .button,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isOn = .constant(isOn)
        self.cornerSize = cornerSize
        self.behavior = behavior
        self.action = action
        self.content = content
    }
    
    init(
        isOn: Binding<Bool>,
        cornerSize: CGSize = .init(width: 8, height: 8),
        behavior: Behavior = .button,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isOn = isOn
        self.cornerSize = cornerSize
        self.behavior = behavior
        self.action = action
        self.content = content
    }
    
    var body: some View {
        Button {
            action()
            
            if behavior == .toggle {
                isOn.toggle()
            }
        } label: {
            content()
                .foregroundStyle(
                    isOn
                    ? AnyShapeStyle(BackgroundStyle.background)
                    : AnyShapeStyle(HierarchicalShapeStyle.primary)
                )
        }
        .buttonStyle(.borderless)
        .buttonBorderShape(.capsule)
        .background {
            if isOn {
                RoundedRectangle(cornerSize: cornerSize)
                    .fill(.tint)
                    .strokeBorder(.fill.opacity(isHovering ? 0.25 : 0))
                    .brightness(isHovering ? -0.05 : 0)
            } else {
                RoundedRectangle(cornerSize: cornerSize)
                    .fill(
                        isHovering
                        ? AnyShapeStyle(TintShapeStyle.tint.opacity(0.1))
                        : AnyShapeStyle(FillShapeStyle.fill.opacity(0.1))
                    )
                    .strokeBorder((
                        isHovering
                        ? AnyShapeStyle(TintShapeStyle.tint)
                        : AnyShapeStyle(FillShapeStyle.fill)
                    ).opacity(0.5))
            }
        }
        .animation(.default.speed(2), value: isOn)
        .onHover { isHovering in
            withAnimation(.default.speed(2)) {
                self.isHovering = isHovering
            }
        }
    }
}

#Preview {
    VStack {
        Box(isOn: true) {
            Text("On")
                .padding()
        }
        
        Box(isOn: false) {
            Text("Off")
                .padding()
        }
    }
    .padding()
}
