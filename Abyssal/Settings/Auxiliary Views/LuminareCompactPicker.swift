//
//  LuminareCompactPicker.swift
//  Clipchop
//
//  Created by Xinshao_Air on 2024/7/28.
//

import SwiftUI
import Luminare

struct LuminareCompactPicker<Label: View, SelectionValue: Hashable & Equatable, Content: View>: View {
    let elements: [SelectionValue]
    @Binding var selection: SelectionValue
    @ViewBuilder let content: (SelectionValue) -> Content
    @ViewBuilder let label: () -> Label
    
    let elementMinHeight: CGFloat = 34
    let horizontalPadding: CGFloat = 8
    
    let infoView: LuminareInfoView? = nil
    let disabled: Bool = false

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                label()
                
                if let infoView {
                    infoView
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Menu {
                ForEach(elements, id: \.self) { element in
                    Toggle(isOn: .init(
                        get: {
                            selection == element
                        },
                        set: { _ in
                            selection = element
                        }
                    )) {
                        content(element)
                    }
                }
            } label: {
                content($selection.wrappedValue)
                    .animation(LuminareConstants.animation, value: selection)
            }
            .menuStyle(.borderlessButton)
            .frame(maxWidth: 150)
            .clipShape(Capsule())
            .fixedSize()
            .padding(4)
            .background {
                ZStack {
                    Capsule()
                        .strokeBorder(.quaternary, lineWidth: 1)
                    
                    Capsule()
                        .foregroundStyle(.quinary.opacity(0.5))
                }
            }
            .disabled(disabled)
        }
        .padding(.horizontal, horizontalPadding)
        .frame(minHeight: elementMinHeight)
    }
}


