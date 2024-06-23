//
//  Localizations.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/26.
//

import Foundation

@available(*, deprecated)
struct Localizations {
    struct FeedbackIntensity {
        static let light =      NSLocalizedString("FeedbackIntensity/Light",        value: "Light",     comment: "feedback intensity light")
        static let medium =     NSLocalizedString("FeedbackIntensity/Medium",       value: "Medium",    comment: "feedback intensity medium")
        static let heavy =      NSLocalizedString("FeedbackIntensity/Heavy",        value: "Heavy",      comment: "feedback intensity heavy")
        static let disabled =   NSLocalizedString("FeedbackIntensity/Disabled",     value: "Disabled",  comment: "feedback intensity disabled")
    }
}
