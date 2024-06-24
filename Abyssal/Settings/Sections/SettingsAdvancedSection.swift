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
    @Default(.timeout) private var timeout
    
    private let timeoutTip = Tip(preferredEdge: .minY) {
        TipTimeoutTitle()
    } content: {
        .init(localized: """
Test
""")
    }
    
    private let startsWithMacOSTip = Tip {
        .init(localized: """
Launch **\(Bundle.main.appName)** right after macOS starts.
""")
    }
    
    var body: some View {
        Section("Advanced") {
            timeout: do {
                let maxIndex = TimeoutAttribute.allCases.endIndex - 1
                let binding = Binding<Double> {
                    Double(TimeoutAttribute.allCases.firstIndex(of: timeout) ?? maxIndex)
                } set: { index in
                    timeout = TimeoutAttribute.allCases[Int(index)]
                }
                
                EmptyFormWrapper {
                    Text("Timeout")
                        .opacity(timeout == .forever ? 0.45 : 1)
                        .animation(.default, value: timeout)
                    
                    TipWrapper(alwaysVisible: true, value: $timeout, tip: timeoutTip) { tip in
                        Slider(value: binding, in: 0...Double(maxIndex), step: 1)
                    }
                }
            }
            
            TipWrapper(tip: startsWithMacOSTip) { tip in
                LaunchAtLogin.Toggle("Starts with macOS")
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
