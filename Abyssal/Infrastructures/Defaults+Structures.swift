//
//  Defaults+Structures.swift
//  Abyssal
//
//  Created by KrLite on 2024/2/8.
//

import Foundation
import Defaults
import AppKit

struct ModifiersAttribute: Defaults.Serializable {
    
    var control: Bool
    
    var option: Bool
    
    var command: Bool
    
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
    
    case sec5 = 5
    
    case sec10 = 10
    
    case sec15 = 15
    
    case sec30 = 30
    
    case sec45 = 45
    
    case sec60 = 60
    
    case min2 = 120
    
    case min3 = 180
    
    case min5 = 300
    
    case min10 = 600
    
    case forever = 0
    
    var attribute: Int? {
        switch self {
        case .forever: nil
        default: self.rawValue
        }
    }
    
    var label: String {
        switch self {
        case .sec5: Localizations.FormattedTime.inSeconds(5)
        case .sec10: Localizations.FormattedTime.inSeconds(10)
        case .sec15: Localizations.FormattedTime.inSeconds(15)
        case .sec30: Localizations.FormattedTime.inSeconds(30)
        case .sec45: Localizations.FormattedTime.inSeconds(45)
        case .sec60: Localizations.FormattedTime.inMinutes(1)
        case .min2: Localizations.FormattedTime.inMinutes(2)
        case .min3: Localizations.FormattedTime.inMinutes(3)
        case .min5: Localizations.FormattedTime.inMinutes(5)
        case .min10: Localizations.FormattedTime.inMinutes(10)
        default: Localizations.FormattedTime.forever
        }
    }
    
}

enum FeedbackAttribute: Int, Defaults.Serializable {
    
    case none = 0
    
    case light = 1
    
    case medium = 2
    
    case heavy = 3
    
    var pattern: [NSHapticFeedbackManager.FeedbackPattern?] {
        switch self {
        case .none: [.levelChange]
        case .light: [.generic, nil, .alignment]
        case .medium: [.levelChange, .alignment, .alignment, nil, nil, nil, .levelChange]
        default: []
        }
    }
    
    var label: String {
        switch self {
        case .none: Localizations.FeedbackIntensity.light
        case .light: Localizations.FeedbackIntensity.medium
        case .medium: Localizations.FeedbackIntensity.heavy
        default: Localizations.FeedbackIntensity.disabled
        }
    }
}

struct DeadZoneAttribute: Defaults.Serializable {
    
    var percentage: Double
    
    static let range = 0.0...0.75
    
    var semantic: String {
        String(format: "%d%%", Int(percentage * 100))
    }
    
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
