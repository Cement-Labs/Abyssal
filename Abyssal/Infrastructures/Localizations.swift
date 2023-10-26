//
//  Localizations.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/26.
//

import Foundation

struct Localizations {
    
    struct FormattedTime {
        
        static let seconds = NSLocalizedString("FormattedTime/Seconds", value: "%lld seconds", comment: "(int) + seconds")
        
        static let minutes = NSLocalizedString("FormattedTime/Minutes", value: "%lld minutes", comment: "(int) + minutes")
        
        static let forever = NSLocalizedString("FormattedTime/Forever", value: "Forever", comment: "forever")
        
        static func orElseForever(
            _ number: Any?,
            unit: String
        ) -> String {
            if let number = number as? Int {
                String(format: unit, number)
            } else {
                forever
            }
        }
        
        static func inSeconds(_ number: Any?) -> String {
            orElseForever(number, unit: seconds)
        }
        
        static func inMinutes(_ number: Any?) -> String {
            orElseForever(number, unit: minutes)
        }
        
    }
    
    struct FeedbackIntensity {
        
        static let light = NSLocalizedString("FeedbackIntensity/Light", value: "Light", comment: "feedback intensity light")
        
        static let medium = NSLocalizedString("FeedbackIntensity/Medium", value: "Medium", comment: "feedback intensity medium")
        
        static let heavy = NSLocalizedString("FeedbackIntensity/Heavy", value: "Heavy", comment: "feedback intensity heavy")
        
        static let disabled = NSLocalizedString("FeedbackIntensity/Disabled", value: "Disabled", comment: "feedback intensity disabled")
        
    }
    
}
