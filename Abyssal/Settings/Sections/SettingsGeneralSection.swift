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
    @Default(.autoShowsEnabled) private var autoShowsEnabled
    @Default(.feedback) private var feedback
    @Default(.alwaysHideAreaEnabled) private var alwaysHideAreaEnabled
    @Default(.reduceAnimationEnabled) private var reduceAnimationEnabled
    
    private let feedbackTip = Tip {
        FeedbackTipContent()
    }
    
    var body: some View {
        Section {
            SpacingVStack {
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
                
                Toggle("Reduce animation", isOn: $reduceAnimationEnabled)
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
         
        Section("Functions") {
            SpacingVStack {
                Toggle("Auto shows", isOn: $autoShowsEnabled)
                
                Toggle("Use always hide area", isOn: $alwaysHideAreaEnabled)
            }
        }
         
        Section {
            SpacingVStack {
                Picker("Auto idling", selection: .constant(1)) {
                    Text("Test 1").tag(1)
                    Text("Test 2").tag(2)
                }
                
                Picker("Edge behavior", selection: .constant(1)) {
                    Text("Test 1").tag(1)
                    Text("Test 2").tag(2)
                }
            }
            
            VStack {
                Picker(selection: .constant(1)) {
                    Text("Percentage").tag(1)
                    Text("Pixel").tag(2)
                } label: {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Dead zone")
                        
                        Spacer()
                        
                        if autoShowsEnabled {
                            Stepper(value: .constant(42), in: 0...Int.max) {
                                TextField(text: .constant("42")) {
                                    EmptyView()
                                }
                                .multilineTextAlignment(.trailing)
                                .lineLimit(1)
                                .monospaced()
                            }
                        }
                    }
                }
                
                EmptyFormWrapper {
                    Slider(value: .constant(0.25), in: 0...1) {
                        EmptyView()
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
