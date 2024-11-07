//
//  DeadzoneSlider.swift
//  Abyssal
//
//  Created by KrLite on 2024/11/6.
//

import SwiftUI
import Luminare
import Defaults

struct DeadzoneSlider: View {
    @Default(.displaySettings) private var displaySettings

    var body: some View {
        LuminareValueAdjusterCompose(
            "Deadzone",
            value: $displaySettings.main.deadzone.value,
            sliderRange: displaySettings.main.deadzone.range,
            controlSize: .compact
        ) { view in
            HStack(spacing: 2) {
                view

                Picker("", selection: $displaySettings.main.deadzone.mode) {
                    ForEach(Deadzone.Mode.allCases, id: \.self) { mode in
                        switch mode {
                        case .percentage:
                            Text("%")
                        case .pixel:
                            Text("px")
                        }
                    }
                }
                .labelsHidden()
                .buttonStyle(.borderless)
                .padding(.trailing, -6)
            }
            .monospaced()
        }
    }
}

#Preview {
    LuminareSection {
        DeadzoneSlider()
    }
    .padding()
}
