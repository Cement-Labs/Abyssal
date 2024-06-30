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
        KeyboardShortcuts.Recorder(for: .toggleActive) {
            VStack {
                Spacer()
                Text("Toggle active")
                Spacer()
            }
        }
        .controlSize(.large)
    }
}

#Preview {
    Form {
        ShortcutsControl()
    }
    .formStyle(.grouped)
}
