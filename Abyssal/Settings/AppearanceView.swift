//
//  AppearanceView.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/20.
//

import SwiftUI
import Luminare
import Defaults

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
    }
}

#Preview {
    AppearanceView()
        .padding()
}
