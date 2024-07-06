//
//  DeadZoneControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct DeadZoneControl: View {
    @Default(.screenSettings) private var screenSettings
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker(selection: $screenSettings.main.deadZone.mode) {
                ForEach(DeadZone.Mode.allCases, id: \.self) { mode in
                    switch mode {
                    case .percentage:
                        Text("%")
                    case .pixel:
                        Text("px")
                    }
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    Text("Dead zone")
                        .opacity(screenSettings.main.respectNotch ? 0.45 : 1)
                    
                    Spacer()
                    
                    Stepper(value: $screenSettings.main.deadZone.value, in: screenSettings.main.deadZone.range, step: 5) {
                        TextField(value: $screenSettings.main.deadZone.value, format: .number.precision(.fractionLength(1))) {
                            EmptyView()
                        }
                        .onSubmit {
                            isTextFieldFocused = false
                        }
                        .aspectRatio(contentMode: .fit)
                        .textFieldStyle(.plain)
                        
                        .monospaced()
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        
                        .focused($isTextFieldFocused)
                        .focusable(false)
                        
                        .animation(.none, value: screenSettings.main.deadZone)
                    }
                }
            }
            
            EmptyFormWrapper {
                TipWrapper(tip: tip, alwaysVisible: true, value: $screenSettings.main.deadZone) { tip in
                    Slider(value: $screenSettings.main.deadZone.value, in: screenSettings.main.deadZone.range) {
                        EmptyView()
                    }
                }
            }
        }
        .disabled(screenSettings.main.respectNotch)
        .animation(.smooth, value: screenSettings.main.deadZone)
        .animation(.smooth, value: screenSettings.main.respectNotch)
    }
    
    private let tip = Tip(preferredEdge: .minY) {
        TipDeadZoneTitle()
    } content: {
        .init(localized: """
""")
    }
}

#Preview {
    Form {
        DeadZoneControl()
    }
    .formStyle(.grouped)
}
