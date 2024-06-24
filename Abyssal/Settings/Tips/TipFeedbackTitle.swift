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
        let label: String = switch feedback {
        case .none:
                .init(localized: "None")
        case .light:
                .init(localized: "Light")
        case .medium:
                .init(localized: "Medium")
        case .heavy:
                .init(localized: "Heavy")
        }
        
        TipTitle(value: $feedback) {
            Text(label)
        }
    }
}

