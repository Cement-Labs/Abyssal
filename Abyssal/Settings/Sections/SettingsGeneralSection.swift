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
            SectionVStack {
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
                        .foregroundStyle(
                            feedback == .none
                            ? AnyShapeStyle(PlaceholderTextShapeStyle())
                            : AnyShapeStyle(ForegroundStyle())
                        )
                        .animation(.default, value: feedback)
                    
                    TipWrapper(alwaysVisible: true, value: $feedback, tip: feedbackTip) { tip in
                        Slider(value: binding, in: 0...Double(maxIndex), step: 1) {
                            EmptyView()
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
        }
         
        Section("Functions") {
            SectionVStack {
                Toggle("Auto shows", isOn: $autoShowsEnabled)
                
                Toggle("Use always hide area", isOn: $alwaysHideAreaEnabled)
            }
        }
         
        Section {
            SectionVStack {
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
