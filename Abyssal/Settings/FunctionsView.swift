//
//  FunctionsView.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/20.
//

import SwiftUI
import Luminare
import Defaults
import KeyboardShortcuts

struct FunctionsView: View {
    @Default(.autoStandbyEnabled) private var autoStandbyEnabled
    @Default(.alwaysHiddenAreaEnabled) private var alwaysHiddenAreaEnabled
    @Default(.displaySettings) private var displaySettings

    var body: some View {
        LuminareSection {
            LuminareCompose("Auto standby", reducesTrailingSpace: true) {
                Toggle("", isOn: $autoStandbyEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            LuminareCompose("Always hidden area", reducesTrailingSpace: true) {
                Toggle("", isOn: $alwaysHiddenAreaEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }
        }

        LuminareSection("Shortcuts") {
            TriggerControl()

            LuminareCompose("Standby", reducesTrailingSpace: true) {
                KeyboardShortcuts.Recorder(for: .toggleStandby)
                    .controlSize(.large)
                    .clipShape(.rect(cornerRadius: 8).inset(by: 2))
                    .padding(-1)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.quaternary, lineWidth: 1)
                    }
            }
        }

        LuminareSection {
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
        } header: {
            HStack {
                if let main = ScreenManager.main {
                    Text("Display \(main.displayID ?? .zero)")

                    Text(String(format: "%1$.0f×%2$.0f", main.frame.width, main.frame.height))
                        .monospaced()
                        .foregroundStyle(.tertiary)
                } else {
                    Text("Unknown Display")
                }

                Spacer()

                Toggle(isOn: $displaySettings.isMainUnique) {
                    Group {
                        if displaySettings.isMainUnique {
                            Text("Revert to Global")
                        } else {
                            Text("Make Unique")
                        }
                    }
                    .opacity(0.85)
                }
                .toggleStyle(.button)
                .buttonStyle(.plain)
                .foregroundStyle(.tint)
            }
        }
        .tint(displaySettings.isMainUnique ? .orange : .accentColor)
    }
}

#Preview {
    FunctionsView()
        .padding()
}
