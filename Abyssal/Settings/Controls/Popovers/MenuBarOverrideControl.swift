//
//  MenuBarOverrideControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/7/3.
//

import SwiftUI
import Defaults

struct MenuBarOverrideControl: View {
    @Default(.autoOverridesMenuBarEnabled) var autoOverridesMenuBarEnabled
    @Default(.menuBarOverride) var menuBarOverride
    
    var body: some View {
        TipWrapper(tip: autoOverridesMenuBarTip) { tip in
            Toggle(isOn: $autoOverridesMenuBarEnabled) {
                Text("Auto overrides menu bar")
            }
        }
        
        Picker("Application menu", selection: $menuBarOverride) {
            ForEach(MenuBarOverride.allCases, id: \.self) { override in
                switch override {
                case .app:
                    Text(Bundle.main.appName)
                case .empty:
                    Text("Nothing")
                }
            }
        }
        .onChange(of: menuBarOverride) { _, override in
            override.apply()
        }
    }
    
    private let autoOverridesMenuBarTip = Tip {
        .init(localized: """
Allow **\(Bundle.main.appName)** to takeover the menu bar when showing this window or toggled manually. **Applies after this window is closed.**
""")
    }
}

#Preview {
    Form {
        MenuBarOverrideControl()
    }
    .formStyle(.grouped)
}
