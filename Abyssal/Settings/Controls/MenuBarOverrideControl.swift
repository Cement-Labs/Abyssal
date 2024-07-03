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
        Toggle(isOn: $autoOverridesMenuBarEnabled) {
            HStack {
                Text("Auto overrides menu bar")
            }
        }
        
        Picker("Application menu", selection: $menuBarOverride) {
            ForEach(MenuBarOverride.allCases, id: \.self) { override in
                switch override {
                case .app:
                    Text(Bundle.main.appName)
                case .empty:
                    Text("Empty")
                }
            }
        }
        .onChange(of: menuBarOverride) { _, override in
            override.apply()
        }
    }
}

#Preview {
    Form {
        MenuBarOverrideControl()
    }
    .formStyle(.grouped)
}
