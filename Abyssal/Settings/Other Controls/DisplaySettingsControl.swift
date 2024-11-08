//
//  DisplaySettingsControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/11/8.
//

import SwiftUI
import Luminare
import Defaults

struct DisplaySettingsControl: View {
    @Default(.displaySettings) private var displaySettings

    var body: some View {
        DeadzoneSlider()

        LuminareCompose("Standby strategy", reducesTrailingSpace: true) {
            Menu {
                Section("On Change") {
                    Toggle("Frontmost Application", isOn: $displaySettings.main.activeStrategy.frontmostAppChange)

                    Toggle("Main Screen", isOn: $displaySettings.main.activeStrategy.screenChange)
                }

                Section("On Invalidation") {
                    Toggle("Menu Bar Interaction", isOn: $displaySettings.main.activeStrategy.interactionInvalidate)
                }
            } label: {
                Text("Satisfying Any of the \(displaySettings.main.activeStrategy.enabledCount) Rules")
            }
            .buttonStyle(.borderless)
            .padding(.trailing, -4)
            .modifier(LuminareHoverable(horizontalPadding: 8))
        }

        LuminareCompose("Respect notch", reducesTrailingSpace: true) {
            Toggle("", isOn: $displaySettings.main.respectNotch)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }
}

#Preview {
    LuminareSection {
        DisplaySettingsControl()
    }
    .padding()
}
