//
//  AlwaysHideAreaControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct AlwaysHideAreaControl: View {
    @Default(.alwaysHideAreaEnabled) private var alwaysHideAreaEnabled
    
    var body: some View {
        TipWrapper(tip: tip) { tip in
            Toggle("Use always hide area", isOn: $alwaysHideAreaEnabled)
        }
    }
    
    private let tip = Tip {
        .init(localized: """
Hide certain status items permanently by moving them to the leading of the `Always Hide Separator`, that is, to the **Always Hide Area.**

The status items inside the **Always Hide Area** will be hidden and kept invisible until the cursor hovers over the spare area with a modifier key down, or while this window is opened.
""")
    }
}

#Preview {
    Form {
        AlwaysHideAreaControl()
    }
    .formStyle(.grouped)
}
