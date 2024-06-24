//
//  SettingsFunctionsSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import SwiftUI
import Defaults

struct SettingsFunctionsSection: View {
    @Default(.autoShowsEnabled) private var autoShowsEnabled
    @Default(.alwaysHideAreaEnabled) private var alwaysHideAreaEnabled
    
    private let autoShowsTip = Tip {
        .init(localized: """
Auto shows the status items inside the **Hide Area** while the cursor is hovering over the spare area.

If this option is enabled, the status items inside the **Hide Area,** which is between the `Hide Separator` (the middle one) and the `Always Hide Separator` (the furthest one from the screen corner), will be hidden and kept invisible, until the cursor hovers over the spare area, where the status items in **Hide Area** used to stay. Otherwise the status items will be hidden until you switch their visibility state manually.

By left clicking on the `Menu Separator` (the nearest one to the screen corner), or clicking using either of the mouse buttons on the other separators, you can manually switch the visibility state of the status items inside the **Hide Area.** If you set them visible, they will never be hidden again until you manually switch their visibility state. Otherwise they will follow the behavior defined above.
""")
    }
    
    private let alwaysHideAreaTip = Tip {
        .init(localized: """
Hide certain status items permanently by moving them left of the `Always Hide Separator` to the **Always Hide Area.**

The status items inside the **Always Hide Area** will be hidden and invisible until the cursor hovers over the spare area with a modifier key down, or while this window is opened.
""")
    }
    
    var body: some View {
        Section("Functions") {
            SpacingVStack {
                TipWrapper(tip: autoShowsTip) { tip in
                    Toggle("Auto shows", isOn: $autoShowsEnabled)
                }
                
                TipWrapper(tip: alwaysHideAreaTip) { tip in
                    Toggle("Use always hide area", isOn: $alwaysHideAreaEnabled)
                }
            }
        }
    }
}

#Preview {
    Form {
        SettingsFunctionsSection()
    }
    .formStyle(.grouped)
}
