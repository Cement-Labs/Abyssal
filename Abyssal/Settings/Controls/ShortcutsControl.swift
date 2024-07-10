//
//  ShortcutsControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/30.
//

import SwiftUI
import KeyboardShortcuts

struct ShortcutsControl: View {
    var body: some View {
        VStack {
            KeyboardShortcuts.Recorder(for: .toggleActive) {
                VStack {
                    Spacer()
                    Text("Toggle active")
                    Spacer()
                }
            }
            
            KeyboardShortcuts.Recorder(for: .toggleMenuBarOverride) {
                VStack {
                    Spacer()
                    Text("Toggle menu bar override")
                    Spacer()
                }
            }
        }
        .controlSize(.large)
    }
    
    private let activeTip = Tip {
        .init(localized: """
The global shortcut used to toggle **\(Bundle.main.appName)**'s active state.
""")
    }
    
    private let menuBarOverrideTip = Tip {
        .init(localized: """
The global shortcut used to toggle menu bar override.
""")
    }
}

#Preview {
    Form {
        ShortcutsControl()
    }
    .formStyle(.grouped)
}
