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
    @Default(.autoShowsEnabled) var autoShowsEnabled
    @Default(.feedback) var feedback
    @Default(.alwaysHideAreaEnabled) var alwaysHideAreaEnabled
    @Default(.reduceAnimationEnabled) var reduceAnimationEnabled
    
    private let feedbackTip = Tip {
        FeedbackTipContent()
    }
    
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
            
            Toggle("Auto shows", isOn: $autoShowsEnabled)
        }
        
        Section {
            feedback: do {
                let maxIndex = FeedbackAttribute.allCases.endIndex - 1
                let binding = Binding<Double> {
                    Double(FeedbackAttribute.allCases.firstIndex(of: feedback) ?? 0)
                } set: { index in
                    feedback = FeedbackAttribute.allCases[Int(index)]
                }
                
                TipWrapper(alwaysVisible: true, value: $feedback, tip: feedbackTip) { tip in
                    Slider(value: binding, in: 0...Double(maxIndex), step: 1) {
                        Text("Haptic feedback")
                    }
                    .introspect(.slider, on: .macOS(.v14, .v15)) { slider in
                        tip.positionRect = {
                            slider.knobRect
                        }
                        tip.hasReactivePosition = true
                        tip.cache(slider)
                    }
                }
            }
        }
        
        Section {
            Toggle("Use always hide area", isOn: $alwaysHideAreaEnabled)
            
            Toggle("Reduce animation", isOn: $reduceAnimationEnabled)
        }
    }
}

#Preview {
    Form {
        SettingsGeneralSection()
    }
    .formStyle(.grouped)
}
