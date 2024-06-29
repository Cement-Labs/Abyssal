//
//  DeadZoneControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct DeadZoneControl: View {
    @Default(.deadZone) var deadZone
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker(selection: $deadZone.mode) {
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
                    
                    Stepper(value: $deadZone.value, in: deadZone.range, step: 5) {
                        TextField(value: $deadZone.value, format: .number.precision(.fractionLength(1))) {
                            EmptyView()
                        }
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .monospaced()
                    }
                }
            }
            
            EmptyFormWrapper {
                TipWrapper(alwaysVisible: true, value: $deadZone, tip: tip) { tip in
                    Slider(value: $deadZone.value, in: deadZone.range) {
                        EmptyView()
                    }
                }
            }
        }
        .animation(.smooth, value: deadZone)
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
