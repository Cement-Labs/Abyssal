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
        Toggle("Respect notch", isOn: $screenSettings.main.respectNotch)
    }
}

#Preview {
    Form {
        RespectNotchControl()
    }
    .formStyle(.grouped)
}
