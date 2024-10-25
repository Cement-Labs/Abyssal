//
//  MenuBarMenuView.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/23.
//

import SwiftUI
import Defaults
import KeyboardShortcuts

struct MenuBarMenuView: View {
    @Default(.isStandby) var isStandby
    
    var body: some View {
        Toggle("Standby", isOn: .init(
            get: { isStandby },
            set: { newValue in
                isStandby = newValue
                AbyssalApp.statusBarController.function()
            }
        ))
        
        Divider()
        
        Button("Settings…") {
            abyssal.openSettings()
        }
        .keyboardShortcut(",", modifiers: .command)
        
        Button("Quit \(Bundle.main.appName)") {
            abyssal.quit(self)
        }
        .keyboardShortcut("q", modifiers: .command)
    }
}
