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
        KeyboardShortcuts.Recorder(for: .toggleCollapse) {
            VStack {
                Spacer()
                Text("Toggle collapse")
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
