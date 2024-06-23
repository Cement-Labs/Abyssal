//
//  SettingsGeneralSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI
import Defaults

struct SettingsGeneralSection: View {
    @Default(.theme) var theme
    
    var body: some View {
        Section {
            Picker("Theme", selection: $theme) {
                ForEach(Theme.themes, id: \.self) { theme in
                    HStack {
                        Image(nsImage: theme.icon.image)
                        Text(theme.name)
                    }
                }
            }
            .onChange(of: theme) { _, _ in
                AppDelegate.shared?.statusBarController.startFunctionalTimers()
            }
        }
    }
}

#Preview {
    Form {
        SettingsGeneralSection()
    }
    .formStyle(.grouped)
}
