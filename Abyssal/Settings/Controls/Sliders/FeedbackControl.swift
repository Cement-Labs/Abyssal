//
//  FeedbackControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct FeedbackControl: View {
    @Default(.feedback) private var feedback
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Haptic feedback")
                .opacity(feedback == .none ? 0.45 : 1)
                .animation(.default, value: feedback)
            
            EmptyFormWrapper {
                let maxIndex = Feedback.allCases.endIndex - 1
                let binding = Binding<Double> {
                    Double(Feedback.allCases.firstIndex(of: feedback) ?? 0)
                } set: { index in
                    feedback = Feedback.allCases[Int(index)]
                }
                
                TipWrapper(tip: tip, alwaysVisible: true, value: $feedback) { tip in
                    Slider(value: binding, in: 0...Double(maxIndex), step: 1) {
                        EmptyView()
                    }
                }
                .onChange(of: feedback) { _, _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        AppDelegate.shared?.statusBarController.startFeedbackTimer()
                    }
                }
            }
        }
    }
    
    private let tip = Tip(preferredEdge: .minY, delay: 0.1) {
        TipFeedbackTitle()
    } content: {
        .init(localized: """
The intensity of feedback given when triggering actions such as _enabling **Auto Shows**_ or _canceling **Auto Idling.**_
""")
    }
}

#Preview {
    Form {
        FeedbackControl()
    }
    .formStyle(.grouped)
}
