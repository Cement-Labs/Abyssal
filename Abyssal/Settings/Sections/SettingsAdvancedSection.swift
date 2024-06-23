//
//  SettingsAdvancedSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI
import Defaults
import LaunchAtLogin
import SwiftUIIntrospect

struct SettingsAdvancedSection: View {
    @Default(.timeout) var timeout
    
    @State private var isHoveringTimeout: Bool = false
    
    private let tipTimeout = Tip {
        TimeoutTip()
    }
    
    var body: some View {
        Section {
            let maxIndex = TimeoutAttribute.allCases.count - 1
            let binding = Binding<Double> {
                Double(TimeoutAttribute.allCases.firstIndex(of: timeout) ?? maxIndex)
            } set: { index in
                timeout = TimeoutAttribute.allCases[Int(index)]
            }
            
            Slider(value: binding, in: 0...Double(maxIndex), step: 1) {
                Text("Timeout")
            }
            .onHover { isHovering in
                isHoveringTimeout = isHovering
                tipTimeout.toggle(show: isHovering)
            }
            .introspect(.slider, on: .macOS(.v14, .v15)) { slider in
                tipTimeout.positionRect = {
                    slider.knobRect
                }
                tipTimeout.hasReactivePosition = true
                tipTimeout.cache(slider)
            }
            .onChange(of: timeout) { oldValue, newValue in
                tipTimeout.updatePosition()
            }
        }
    }
}

#Preview {
    Form {
        SettingsAdvancedSection()
    }
    .formStyle(.grouped)
}
