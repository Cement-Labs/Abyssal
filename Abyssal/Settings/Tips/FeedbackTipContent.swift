//
//  FeedbackTipContent.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI
import Defaults

struct FeedbackTipContent: View {
    @Default(.feedback) var feedback
    
    var body: some View {
        ComposedTip {
            Text("This is a description. **Markdown** ~is~ `actually` *supported!*")
        } title: {
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
            
            Text(label)
                .contentTransition(.numericText(countsDown: true))
                .animation(.smooth, value: feedback)
        }
    }
}

#Preview {
    FeedbackTipContent()
}
