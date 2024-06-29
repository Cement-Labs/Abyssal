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
    
    private let timeoutTip = Tip(preferredEdge: .minY, delay: 0.1) {
        TipTimeoutTitle()
    } content: {
        .init(localized: """
Time to countdown before disabling **Auto Idling.**

After interacting with status items that will be automatically hidden, for example, status items inside the **Always Hidden Area,** **Auto Idling** will keep them visible until this timeout is reached or the cursor hovered over the `Hide Separator` or `Always Hide Separator`.
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
                let maxIndex = Timeout.allCases.endIndex - 1
                let binding = Binding<Double> {
                    Double(Timeout.allCases.firstIndex(of: timeout) ?? maxIndex)
                } set: { index in
                    timeout = Timeout.allCases[Int(index)]
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
