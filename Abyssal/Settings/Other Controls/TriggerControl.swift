//
//  TriggerControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/11/6.
//

import SwiftUI
import Luminare
import Defaults

struct TriggerControl: View {
    @Environment(\.luminareAnimation) private var animation
    @Environment(\.luminareAnimationFast) private var animationFast
    
    @Default(.modifier) private var modifier
    @Default(.modifierCompose) private var modifierCompose
    
    var body: some View {
        LuminareCompose("Trigger", reducesTrailingSpace: true) {
            HStack {
                Group {
                    toggle(isOn: $modifier.control) {
                        expandableLabel(modifier.control) {
                            Text("Control")
                        } image: {
                            Image(systemSymbol: .control)
                        }
                    }
                    
                    toggle(isOn: $modifier.option) {
                        expandableLabel(modifier.option) {
                            Text("Option")
                        } image: {
                            Image(systemSymbol: .option)
                        }
                    }
                    
                    toggle(isOn: $modifier.command) {
                        expandableLabel(modifier.command) {
                            Text("Command")
                        } image: {
                            Image(systemSymbol: .command)
                        }
                    }
                }
            }
            .toggleStyle(.button)
            .buttonStyle(LuminareCompactButtonStyle(extraCompact: true))
            .animation(animation, value: modifier)
        }
    }
    
    @ViewBuilder private func toggle(isOn: Binding<Bool>, @ViewBuilder label: @escaping () -> some View) -> some View {
        Toggle(isOn: isOn) {
            label()
                .frame(height: 30)
                .padding(.horizontal, 8)
                .foregroundStyle(isOn.wrappedValue ? AnyShapeStyle(.background) : AnyShapeStyle(.primary))
                .background {
                    if isOn.wrappedValue {
                        Color.accentColor
                            .modifier(LuminareBordered())
                    } else {
                        Color.clear
                    }
                }
                .animation(animationFast, value: isOn.wrappedValue)
        }
    }
    
    @ViewBuilder private func expandableLabel(
        _ isExpanded: Bool,
        @ViewBuilder text: @escaping () -> some View,
        @ViewBuilder image: @escaping () -> some View
    ) -> some View {
        HStack {
            if isExpanded {
                text()
            }
            
            image()
        }
    }
}

#Preview {
    LuminareSection {
        TriggerControl()
    }
    .padding()
}
