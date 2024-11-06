//
//  FeedbackIntensitySlider.swift
//  Abyssal
//
//  Created by KrLite on 2024/11/6.
//

import SwiftUI
import Luminare
import Defaults

struct FeedbackIntensitySlider: View {
    @Default(.feedback) private var feedback
    
    var body: some View {
        LuminareSliderPickerCompose("Feedback Intensity", Feedback.allCases, selection: $feedback) { feedback in
            Group {
                switch feedback {
                case .none: Text("None")
                case .light: Text("Light")
                case .medium: Text("Medium")
                case .heavy: Text("Heavy")
                }
            }
        }
    }
}

#Preview {
    FeedbackIntensitySlider()
}
