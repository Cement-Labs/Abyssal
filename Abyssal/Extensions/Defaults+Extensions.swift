//
//  Defaults.swift
//  Abyssal
//
//  Created by KrLite on 2024/2/8.
//

import Foundation
import Defaults
import LaunchAtLogin

extension Defaults.Keys {
    static let isCollapsed = Key<Bool>("isCollapsed", default: false)
    
    static let tipsEnabled = Key<Bool>("tipsEnabled", default: true)
    
    static let autoShowsEnabled = Key<Bool>("autoShowsEnabled", default: true)
    
    
    
    static let theme = Key<Theme>("theme", default: Themes.defaultTheme)
    
    static let modifiers = Key<ModifiersAttribute>(
        "modifiers",
        default: [.option, .command]
    )
    
    static let modifiersMode = Key<ModifiersAttribute.Mode>(
        "modifiersMode",
        default: .any
    )
    
    
    
    static let timeout = Key<TimeoutAttribute>(
        "timeout",
        default: .sec30
    )
    
    static let feedback = Key<FeedbackAttribute>(
        "feedback",
        default: .medium
    )
    
    static let deadZone = Key<DeadZoneAttribute>(
        "deadZone",
        default: DeadZoneAttribute(percentage: 0.25)
    )
    
    
    
    static let alwaysHideAreaEnabled = Key<Bool>("alwaysHideAreaEnabled", default: true)
    
    static let reduceAnimationEnabled = Key<Bool>("reduceAnimationEnabled", default: false)
    
    static let launchAtLogin = Key<Bool>("launchAtLogin", default: false)
}
