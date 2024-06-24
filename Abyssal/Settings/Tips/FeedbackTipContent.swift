//
//  FeedbackTipContent.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI
import Defaults

struct FeedbackTipContent: View {
    @Default(.feedback) private var feedback
    
    var body: some View {
        ComposedTipContent {
            Text("""
The intensity of feedback given when triggering actions such as _enabling **Auto Shows**_ or _canceling **Auto Idling.**_
""")
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
