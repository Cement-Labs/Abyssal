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
            Text("""
Time to countdown before disabling **Auto Idling.**

After interacting with status items that will be automatically hidden, for example, status items inside the **Always Hidden Area,** **Auto Idling** will keep them visible until this timeout is reached or the cursor hovered over the `Hide Separator` or `Always Hide Separator`.
""")
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
