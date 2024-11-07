//
//  FeedbackSlider.swift
//  Abyssal
//
//  Created by KrLite on 2024/11/6.
//

import SwiftUI
import Luminare
import Defaults

struct FeedbackSlider: View {
    @Default(.feedback) private var feedback

    var body: some View {
        LuminareSliderPickerCompose("Feedback intensity", Feedback.allCases, selection: $feedback) { feedback in
            Group {
                switch feedback {
                case .none: Text("None")
                case .light: Text("Light")
                case .medium: Text("Medium")
                case .heavy: Text("Heavy")
                }
            }
            .monospaced()
        }
        .onChange(of: feedback) { _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                AbyssalApp.statusBarController.startFeedbackTimer()
            }
        }
    }
}

#Preview {
    LuminareSection {
        FeedbackSlider()
    }
    .padding()
}
