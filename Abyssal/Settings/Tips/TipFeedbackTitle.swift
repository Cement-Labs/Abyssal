//
//  TipFeedbackTitle.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import SwiftUI
import Defaults

struct TipFeedbackTitle: View {
    @Default(.feedback) private var feedback
    
    var body: some View {
        let label: LocalizedStringKey = switch feedback {
        case .none:
                .init("None")
        case .light:
                .init("Light")
        case .medium:
                .init("Medium")
        case .heavy:
                .init("Heavy")
        }
        
        TipTitle(label, value: $feedback)
    }
}

