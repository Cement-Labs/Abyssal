//
//  ShortcutsSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/30.
//

import SwiftUI

struct ShortcutsSection: View {
    @Environment(\.hasTitle) private var hasTitle
    
    var body: some View {
        Section {
            ShortcutsControl()
        } header: {
            if hasTitle {
                Text("Shortcuts")
            }
        }
    }
}

#Preview {
    Form {
        ShortcutsSection()
    }
    .formStyle(.grouped)
}
