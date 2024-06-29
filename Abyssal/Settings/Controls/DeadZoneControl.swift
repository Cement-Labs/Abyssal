//
//  DeadZoneControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct DeadZoneControl: View {
    @Default(.screenSettings) var screenSettings
    
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
                    
                    Spacer()
                    
                    Stepper(value: $screenSettings.main.deadZone.value, in: screenSettings.main.deadZone.range, step: 5) {
                        TextField(value: $screenSettings.main.deadZone.value, format: .number.precision(.fractionLength(1))) {
                            EmptyView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .monospaced()
                        .animation(.none, value: screenSettings.main.deadZone)
                    }
                }
            }
            
            EmptyFormWrapper {
                TipWrapper(alwaysVisible: true, value: $screenSettings.main.deadZone, tip: tip) { tip in
                    Slider(value: $screenSettings.main.deadZone.value, in: screenSettings.main.deadZone.range) {
                        EmptyView()
                    }
                }
            }
        }
        .animation(.smooth, value: screenSettings.main.deadZone)
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
