//
//  Defaults.swift
//  Abyssal
//
//  Created by KrLite on 2024/2/8.
//

import Foundation
import AppKit
import Defaults
import LaunchAtLogin

extension Defaults.Keys {
    /// - `true`: the expanded state and menu bar itms are hidden.
    /// - `false`: the shrunk state and menu bar items are visible.
    static let isActive = Key<Bool>("isActive", default: false)
    
    static let tipsEnabled = Key<Bool>("tipsEnabled", default: true)
    
    
    
    static let alwaysHideAreaEnabled = Key<Bool>("alwaysHideAreaEnabled", default: true)
    
    static let reduceAnimationEnabled = Key<Bool>("reduceAnimationEnabled", default: false)
    
    static let autoShowsEnabled = Key<Bool>("autoShowsEnabled", default: true)
    
    
    
    static let theme = Key<Theme>("theme", default: .defaultTheme)
    
    static let modifier = Key<Modifier>(
        "modifier",
        default: [.option, .command]
    )
    
    static let modifierMode = Key<Modifier.Mode>(
        "modifierMode",
        default: .any
    )
    
    static let collapseStrategy = Key<CollapseStrategy>(
        "collapseStrategy",
        default: .init(
            frontmostAppChange: true,
            interactionInvalidate: true,
            screenChange: false
        )
    )
    
    static let timeout = Key<Timeout>(
        "timeout",
        default: .sec30
    )
    
    static let feedback = Key<Feedback>(
        "feedback",
        default: .medium
    )
    
    static let deadZone = Key<DeadZone>(
        "deadZone",
        default: .percentage(0.5)
    )
    
    
    
    static let uniqueScreenSettings = Key<[Int: UniqueScreenSetting]>(
        "uniqueScreenSettings",
        default: [:]
    )
}
