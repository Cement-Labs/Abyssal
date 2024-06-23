//
//  TimeoutTip.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI
import Defaults

struct TimeoutTip: View {
    @Default(.tipsEnabled) var tipsEnabled
    @Default(.timeout) var timeout
    
    var body: some View {
        SimpleTip {
            VStack {
                Text(timeout.label)
                    .font(.title2)
                    .bold()
                
                if tipsEnabled {
                    Text("This is a description. **Markdown** ~is~ `actually` *supported!*")
                }
            }
            .contentTransition(.numericText(countsDown: true))
            .animation(.smooth, value: timeout)
        }
    }
}

#Preview {
    TimeoutTip()
}
