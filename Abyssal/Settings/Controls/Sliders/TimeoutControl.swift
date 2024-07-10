//
//  TimeoutControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct TimeoutControl: View {
    @Default(.timeout) private var timeout
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Timeout")
                .opacity(timeout == .forever ? 0.45 : 1)
                .animation(.default, value: timeout)
            
            EmptyFormWrapper {
                let maxIndex = Timeout.allCases.endIndex - 1
                let binding = Binding<Double> {
                    Double(Timeout.allCases.firstIndex(of: timeout) ?? maxIndex)
                } set: { index in
                    timeout = Timeout.allCases[Int(index)]
                }
                
                TipWrapper(tip: timeoutTip, alwaysVisible: true, value: $timeout) { tip in
                    Slider(value: binding, in: 0...Double(maxIndex), step: 1)
                }
            }
        }
    }
    
    private let timeoutTip = Tip(preferredEdge: .minY, delay: 0.1) {
        TipTimeoutTitle()
    } content: {
        .init(localized: """
Time to countdown before disabling **Auto Idling.**

After interacting with status items that will be automatically hidden, for example, status items inside the **Always Hidden Area,** **Auto Idling** will keep them visible until this timeout is reached, the cursor hovered over the `Hide Separator` or `Always Hide Separator`, or the specified active strategy is met.
""")
    }
}

#Preview {
    Form {
        TimeoutControl()
    }
    .formStyle(.grouped)
}
