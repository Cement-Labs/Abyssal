//
//  AppearanceView.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/20.
//

import Defaults
import LaunchAtLogin
import Luminare
import SwiftUI

struct AppearanceView: View {
    @Default(.reduceAnimationEnabled) private var reduceAnimationEnabled

    var body: some View {
        LuminareSection {
            ThemePicker()

            LuminareCompose("Reduce animation", reducesTrailingSpace: true) {
                Toggle("", isOn: $reduceAnimationEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            FeedbackSlider()
        }

        LuminareSection("Advanced") {
            TimeoutSlider()

            LuminareCompose("Starts with macOS", reducesTrailingSpace: true) {
                LaunchAtLogin.Toggle()
                    .labelsHidden()
                    .toggleStyle(.switch)
            }
        }
    }
}

#Preview {
    AppearanceView()
        .padding()
}
