//
//  Defaults.swift
//  Abyssal
//
//  Created by KrLite on 2024/2/8.
//

import Foundation
import Defaults

extension Defaults.Keys {
    
    static let isCollapsed = Key<Bool>("isCollapsed", default: false)
    
    
    
    static let modifiers = Key<[Bool]>("modifiers", default: [false, true, true])
    
    static let timeoutAttribute = Key<TimeoutAttribute>("timeoutAttribute", default: .sec30)
    
    static let tipsEnabled = Key<Bool>("tipsEnabled", default: true)
    
    
    
    static let theme = Key<Theme>("theme", default: Themes.defaultTheme)
    
    static let autoShowsEnabled = Key<Bool>("autoShowsEnabled", default: true)
    
    static let feedbackAttribute = Key<FeedbackAttribute>("feedbackAttribute", default: .medium)
    
    static let deadZone = Key<>()
    
    
    
    static let alwaysHideAreaEnabled = Key<Bool>("alwaysHideAreaEnabled", default: true)
    
    static let reduceAnimationEnabled = Key<Bool>("reduceAnimationEnabled", default: false)
    
}

extension Defaults {
    
    static let timeoutSliderRange = NSRange(location: 0, length: 11)
    
    static let feedbackIntensitySliderRange = NSRange(location: 0, length: 4)
    
}
