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
        VStack {
            Text("Test")
                .font(.title)
                .bold()
            
            Text("This is a description. **Markdown** ~is~ `actually` *supported!*")
        }
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
                Text("Test")
            }
            .onHover { isHovering in
                isHoveringTimeout = isHovering
            }
            .introspect(.slider, on: .macOS(.v14, .v15)) { slider in
                tipTimeout.positionRect = {
                    slider.knobRect
                }
                tipTimeout.show(slider)
                print(tipTimeout)
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
