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
    
    private let timeoutTip = Tip {
        TimeoutTipContent()
    }
    
    private let startsWithMacOSTip = Tip {
        SimpleTip {
            Text("This is a simple tip.")
        }
    }
    
    var body: some View {
        Section {
            timeout: do {
                let maxIndex = TimeoutAttribute.allCases.endIndex - 1
                let binding = Binding<Double> {
                    Double(TimeoutAttribute.allCases.firstIndex(of: timeout) ?? maxIndex)
                } set: { index in
                    timeout = TimeoutAttribute.allCases[Int(index)]
                }
                
                TipWrapper(alwaysVisible: true, value: $timeout, tip: timeoutTip) { tip in
                    Slider(value: binding, in: 0...Double(maxIndex), step: 1) {
                        Text("Timeout")
                    }
                    .introspect(.slider, on: .macOS(.v14, .v15)) { slider in
                        tip.positionRect = {
                            slider.knobRect
                        }
                        tip.hasReactivePosition = true
                        tip.cache(slider)
                    }
                }
            }
            
            TipWrapper(tip: startsWithMacOSTip) { tip in
                LaunchAtLogin.Toggle("Starts with macOS")
                    .introspect(.toggle(style: .switch), on: .macOS(.v14, .v15)) { toggle in
                        tip.updatePosition()
                        tip.cache(toggle)
                    }
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
