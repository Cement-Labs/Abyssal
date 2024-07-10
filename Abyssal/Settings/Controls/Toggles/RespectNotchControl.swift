//
//  RespectNotchControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct RespectNotchControl: View {
    @Default(.screenSettings) private var screenSettings
    
    var body: some View {
        TipWrapper(tip: respectNotchTip) { tip in
            Toggle("Respect notch", isOn: $screenSettings.main.respectNotch)
        }
    }
    
    private let respectNotchTip = Tip {
        .init(localized: """
If the screen has a notch, use the menu bar's trailing side of the notch as available area and ignore dead zone settings.
""")
    }
}

#Preview {
    Form {
        RespectNotchControl()
    }
    .formStyle(.grouped)
}
