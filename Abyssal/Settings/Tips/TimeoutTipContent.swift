//
//  TimeoutTipContent.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI
import Defaults

struct TimeoutTipContent: View {
    @Default(.timeout) private var timeout
    
    var body: some View {
        ComposedTipContent {
            Text("This is a description. **Markdown** ~is~ `actually` *supported!*")
        } title: {
            Text(timeout.label)
                .contentTransition(.numericText(countsDown: true))
                .animation(.smooth, value: timeout)
        }
    }
}

#Preview {
    TimeoutTipContent()
}
