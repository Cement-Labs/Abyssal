//
//  AutoShowsControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct AutoShowsControl: View {
    @Default(.autoShowsEnabled) private var autoShowsEnabled
    
    var body: some View {
        TipWrapper(tip: tip) { tip in
            Toggle("Auto shows", isOn: $autoShowsEnabled)
        }
    }
    
    private let tip = Tip {
        .init(localized: """
Auto shows the status items inside the **Hide Area** while the cursor is hovering over the spare area.

If this option is enabled, the status items inside the **Hide Area,** which is between the `Hide Separator` (the middle one) and the `Always Hide Separator` (the furthest one from the screen corner), will be hidden and kept invisible, until the cursor hovers over the spare area, where the status items in **Hide Area** used to stay. Otherwise the status items will be hidden until you switch their visibility state manually.

By left clicking on the `Menu Separator` (the nearest one to the screen corner), or clicking using either of the mouse buttons on the other separators, you can manually switch the visibility state of the status items inside the **Hide Area.** If you set them visible, they will never be hidden again until you manually switch their visibility state. Otherwise they will follow the behavior defined above.
""")
    }
}

#Preview {
    Form {
        AutoShowsControl()
    }
    .formStyle(.grouped)
}
