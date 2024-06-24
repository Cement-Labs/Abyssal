//
//  SettingsGeneralSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI
import Defaults

struct SettingsGeneralSection: View {
    @Default(.theme) private var theme
    @Default(.reduceAnimationEnabled) private var reduceAnimationEnabled
    @Default(.feedback) private var feedback
    
    private let feedbackTip = Tip(preferredEdge: .minY) {
        switch Defaults[.feedback] {
        case .none:
                .init(localized: "None")
        case .light:
                .init(localized: "Light")
        case .medium:
                .init(localized: "Medium")
        case .heavy:
                .init(localized: "Heavy")
        }
    } content: {
        .init(localized: """
The intensity of feedback given when triggering actions such as _enabling **Auto Shows**_ or _canceling **Auto Idling.**_
""")
    }
    
    private let themeTip = Tip {
        .init(localized: """
Some themes will hide the icons inside the separators automatically, while others not.

Themes that automatically hide the icons will only show them when the status items inside the **Hide Area** are manually set to visible, while other themes indicate this by reducing the separators' opacity.
""")
    }
    
    private let reduceAnimationTip = Tip {
        .init(localized: """
Reduce animation to gain a more performant experience.
""")
    }
    
    var body: some View {
        Section {
            SpacingVStack {
                TipWrapper(tip: themeTip) { tip in
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
                
                TipWrapper(tip: reduceAnimationTip) { tip in
                    Toggle("Reduce animation", isOn: $reduceAnimationEnabled)
                }
            }
            
            feedback: do {
                let maxIndex = FeedbackAttribute.allCases.endIndex - 1
                let binding = Binding<Double> {
                    Double(FeedbackAttribute.allCases.firstIndex(of: feedback) ?? 0)
                } set: { index in
                    feedback = FeedbackAttribute.allCases[Int(index)]
                }
                
                EmptyFormWrapper {
                    Text("Haptic feedback")
                        .opacity(feedback == .none ? 0.45 : 1)
                        .animation(.default, value: feedback)
                    
                    TipWrapper(alwaysVisible: true, value: $feedback, tip: feedbackTip) { tip in
                        Slider(value: binding, in: 0...Double(maxIndex), step: 1) {
                            EmptyView()
                        }
                    }
                }
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
