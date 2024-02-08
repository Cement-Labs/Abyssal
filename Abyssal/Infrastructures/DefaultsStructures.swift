//
//  DefaultsStructures.swift
//  Abyssal
//
//  Created by KrLite on 2024/2/8.
//

import Foundation
import Defaults
import AppKit

struct ModifiersAttribute: Defaults.Serializable {
    
    let control: Bool
    let option: Bool
    let command: Bool
    
    struct Bridge: Defaults.Bridge {
        
        typealias Value = ModifiersAttribute
        
        typealias Serializable = (control: Bool, option: Bool, command: Bool)
        
        func serialize(_ value: ModifiersAttribute?) -> (control: Bool, option: Bool, command: Bool)? {
            guard let value else {
                return nil
            }
            
            return (
                control: value.control,
                option: value.option,
                command: value.command
            )
        }
        
        func deserialize(_ object: (control: Bool, option: Bool, command: Bool)?) -> ModifiersAttribute? {
            guard let object else {
                return nil
            }
            
            return .init(control: object.control, option: object.option, command: object.command)
        }
        
    }
    
    static let bridge = Bridge()
    
}

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

struct DeadZoneAttribute: Defaults.Serializable {
    
    let percentage: Double
    
    static let range = 0.0...1.0
    
    struct Bridge: Defaults.Bridge {
        
        typealias Value = DeadZoneAttribute
        
        typealias Serializable = Double
        
        func serialize(_ value: DeadZoneAttribute?) -> Double? {
            guard let value else {
                return nil
            }
            
            return value.percentage
        }
        
        func deserialize(_ object: Double?) -> DeadZoneAttribute? {
            guard let object, DeadZoneAttribute.range.contains(object) else {
                return nil
            }
            
            return .init(percentage: object)
        }
        
    }
    
    static let bridge = Bridge()
    
}

extension Theme: Defaults.Serializable {
    
    struct Bridge: Defaults.Bridge {
        
        typealias Value = Theme
        typealias Serializable = Int
        
        func serialize(_ value: Theme?) -> Int? {
            guard let value else {
                return nil
            }
            
            return Themes.themes.firstIndex(of: value)
        }
        
        func deserialize(_ object: Int?) -> Theme? {
            guard
                let index = object,
                index < Themes.themes.count
            else {
                return nil
            }
            
            return Themes.themes[index]
        }
        
    }
    
    static let bridge = Bridge()
    
}
