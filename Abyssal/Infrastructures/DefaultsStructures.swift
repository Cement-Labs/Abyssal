//
//  DefaultsStructures.swift
//  Abyssal
//
//  Created by KrLite on 2024/2/8.
//

import Foundation
import Defaults
import AppKit

enum TimeoutAttribute: Int, Defaults.Serializable {
    
    case sec5 = 0
    case sec10 = 1
    case sec15 = 2
    case sec30 = 3
    case sec45 = 4
    case sec60 = 5
    case sec60_2 = 6
    case sec60_3 = 7
    case sec60_5 = 8
    case sec60_10 = 9
    case forever = 10
    
    var value: (attr: Int?, label: String) {
        return switch self {
        case .sec5:
            (
                attr: 5,
                label: Localizations.FormattedTime.inSeconds(5)
            )
        case .sec10:
            (
                attr: 10,
                label: Localizations.FormattedTime.inSeconds(10)
            )
        case .sec15:
            (
                attr: 15,
                label: Localizations.FormattedTime.inSeconds(15)
            )
        case .sec30:
            (
                attr: 30,
                label: Localizations.FormattedTime.inSeconds(30)
            )
        case .sec45:
            (
                attr: 45,
                label: Localizations.FormattedTime.inSeconds(45)
            )
        case .sec60:
            (
                attr: 60,
                label: Localizations.FormattedTime.inMinutes(1)
            )
        case .sec60_2:
            (
                attr: 60 * 2,
                label: Localizations.FormattedTime.inMinutes(2)
            )
        case .sec60_3:
            (
                attr: 60 * 3,
                label: Localizations.FormattedTime.inMinutes(3)
            )
        case .sec60_5:
            (
                attr: 60 * 5,
                label: Localizations.FormattedTime.inMinutes(5)
            )
        case .sec60_10:
            (
                attr: 60 * 10,
                label: Localizations.FormattedTime.inMinutes(10)
            )
        default:
            (
                attr: nil,
                label: Localizations.FormattedTime.forever)
        }
    }
    
}

enum FeedbackAttribute: Int, Defaults.Serializable {
    
    case none = 0
    case light = 1
    case medium = 2
    case heavy = 3
    
    var value: (feedback: [NSHapticFeedbackManager.FeedbackPattern?], label: String) {
        return switch self {
        case .none:
            (
                feedback: [.levelChange],
                label: Localizations.FeedbackIntensity.light
            )
        case .light:
            (
                feedback: [.generic, nil, .alignment],
                label: Localizations.FeedbackIntensity.medium
            )
        case .medium:
            (
                feedback: [.levelChange, .alignment, .alignment, nil, nil, nil, .levelChange],
                label: Localizations.FeedbackIntensity.heavy
            )
        default:
            (
                feedback: [],
                label: Localizations.FeedbackIntensity.disabled
            )
        }
    }
}

struct ThemeBridge: Defaults.Bridge {
    
    typealias Value = Theme
    
    typealias Serializable = Int
    
    func serialize(_ value: Theme?) -> Int? {
        guard let value else {
            return Themes.themes.firstIndex(of: Themes.defaultTheme)
        }
        
        return Themes.themes.firstIndex(of: value)
    }
    
    func deserialize(_ object: Int?) -> Theme? {
        guard
            let index = object,
            index < Themes.themes.count
        else {
            return Themes.defaultTheme
        }
        
        return Themes.themes[index]
    }
    
}

extension Theme: Defaults.Serializable {
    
    static let bridge = ThemeBridge()
    
}
