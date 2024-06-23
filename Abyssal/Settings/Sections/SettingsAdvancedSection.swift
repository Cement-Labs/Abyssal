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
    
    var body: some View {
        Section {
            let maxIndex = TimeoutAttribute.allCases.count - 1
            let binding = Binding<Double> {
                Double(TimeoutAttribute.allCases.firstIndex(of: timeout) ?? maxIndex)
            } set: { index in
                timeout = TimeoutAttribute.allCases[Int(index)]
            }
            
            Slider(value: binding, in: 0...1, step: 1) {
                Text("Test")
            }
            .introspect(.slider, on: .macOS(.v14, .v15)) { slider in
                print(slider)
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
