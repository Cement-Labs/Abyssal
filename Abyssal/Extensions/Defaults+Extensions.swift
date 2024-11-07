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
    static let isStandby = Key<Bool>("isStandby", default: false)

    static let tipsEnabled = Key<Bool>("tipsEnabled", default: true)

    static let alwaysHiddenAreaEnabled = Key<Bool>("alwaysHiddenAreaEnabled", default: true)

    static let reduceAnimationEnabled = Key<Bool>("reduceAnimationEnabled", default: false)

    static let autoStandbyEnabled = Key<Bool>("autoStandbyEnabled", default: true)

    static let theme = Key<Theme>("theme", default: .defaultTheme)

    static let modifier = Key<Modifier>(
        "modifier",
        default: [.option, .command]
    )

    static let modifierCompose = Key<Modifier.Compose>(
        "modifierCompose",
        default: .any
    )

    static let timeout = Key<Timeout>(
        "timeout",
        default: .sec30
    )

    static let feedback = Key<Feedback>(
        "feedback",
        default: .medium
    )

    static let displaySettings = Key<DisplaySettings>(
        "displaySettings",
        default: .init(
            global: .init(
                activeStrategy: .init(
                    frontmostAppChange: true,
                    interactionInvalidate: true,
                    screenChange: false
                ),
                deadzone: .percentage(50),
                respectNotch: true
            ),
            unique: [:]
        )
    )
}
