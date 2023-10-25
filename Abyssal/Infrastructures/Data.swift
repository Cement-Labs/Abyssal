//
//  Data.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/14.
//

import AppKit
import LaunchAtLogin

public enum Data {
    
    class Keys {
        
        static let collapsed = "Collapsed"
        
        
        
        static let modifiers = "Modifiers"
        
        static let timeout = "Timeout"
        
        static let tips = "Tips"
        
        
        
        static let theme = "Theme"
        
        static let feedbackIntensity = "FeedbackIntensity"
        
        
        
        static let autoShows = "AutoShows"
        
        static let useAlwaysHideArea = "AlwaysHide"
        
        static let reduceAnimation = "ReduceAnimation"
        
    }
    
    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [Keys.collapsed: false])
        
        UserDefaults.standard.register(defaults: [Keys.modifiers: [false, true, true]])
        UserDefaults.standard.register(defaults: [Keys.timeout: 3])
        UserDefaults.standard.register(defaults: [Keys.tips: true])

        UserDefaults.standard.register(defaults: [Keys.theme: Themes.abyssal.name])
        UserDefaults.standard.register(defaults: [Keys.feedbackIntensity: 0])
        
        UserDefaults.standard.register(defaults: [Keys.autoShows: true])
        UserDefaults.standard.register(defaults: [Keys.useAlwaysHideArea: true])
        UserDefaults.standard.register(defaults: [Keys.reduceAnimation: false])
    }
    
    static var modifiers: (control: Bool, option: Bool, command: Bool) {
        get {
            let defaultTuple = (control: false, option: true, command: true)
            
            if let array = UserDefaults.standard.array(forKey: Keys.modifiers) as? [Bool] {
                guard array.count == Mirror(reflecting: defaultTuple).children.count
                else {
                    return defaultTuple
                }
                        
                return (control: array[0], option: array[1], command: array[2])
            } else {
                return defaultTuple
            }
        }
        
        set(modifiers) {
            UserDefaults.standard.set(
                [modifiers.control, modifiers.option, modifiers.command],
                forKey: Keys.modifiers
            )
        }
    }
    
    static var timeout: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.timeout)
        }
        
        set(timeout) {
            UserDefaults.standard.set(
                timeout,
                forKey: Keys.timeout
            )
        }
    }
    
    static let timeoutTickMarks: Int = 11
    
    static var timeoutAttribute: (attr: Int?, label: String) {
        switch timeout {
        case 0:
            return (attr: 5, label: Helper.FormattedTime.inSeconds(5))
        case 1:
            return (attr: 10, label: Helper.FormattedTime.inSeconds(10))
        case 2:
            return (attr: 15, label: Helper.FormattedTime.inSeconds(15))
        case 3:
            return (attr: 30, label: Helper.FormattedTime.inSeconds(30))
        case 4:
            return (attr: 45, label: Helper.FormattedTime.inSeconds(45))
        case 5:
            return (attr: 60, label: Helper.FormattedTime.inMinutes(1))
        case 6:
            return (attr: 60 * 2, label: Helper.FormattedTime.inMinutes(2))
        case 7:
            return (attr: 60 * 3, label: Helper.FormattedTime.inMinutes(3))
        case 8:
            return (attr: 60 * 5, label: Helper.FormattedTime.inMinutes(5))
        case 9:
            return (attr: 60 * 10, label: Helper.FormattedTime.inMinutes(10))
        default:
            return (attr: nil, label: Helper.FormattedTime.FOREVER)
        }
    }
    
    static var tips: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.tips)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.tips)
        }
    }
    
    
    
    static var theme: Theme {
        get {
            let index = UserDefaults.standard.integer(forKey: Keys.theme)
            
            guard index < Themes.themes.count else {
                return Themes.defaultTheme
            }
            
            return Themes.themes[index]
        }
        
        set(theme) {
            UserDefaults.standard.set(
                Themes.themes.firstIndex(of: theme),
                forKey: Keys.theme
            )
        }
    }
    
    
    
    static var feedbackIntensity: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.feedbackIntensity)
        }
        
        set(intensity) {
            UserDefaults.standard.set(intensity, forKey: Keys.feedbackIntensity)
        }
    }
    
    static let feedbackIntensityTickMarks: Int = 4
    
    static var feedbackAttribute: (feedback: [NSHapticFeedbackManager.FeedbackPattern?], label: String) {
        switch feedbackIntensity {
        case 1:
            return (
                feedback: [.levelChange],
                label: String(localized: "Light", comment: "feedback intensity light")
            )
        case 2:
            return (
                feedback: [.generic, nil, .alignment],
                label: String(localized: "Medium", comment: "feedback intensity medium")
            )
        case 3:
            return (
                feedback: [.levelChange, .alignment, .alignment, nil, nil, nil, .levelChange],
                label: String(localized: "Heavy", comment: "feedback intensity heavy")
            )
        default:
            return (
                feedback: [],
                label: String(localized: "Disabled", comment: "feedback intensity disabled")
            )
        }
    }
    
    
    
    static var collapsed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.collapsed)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.collapsed)
        }
    }
    
    
    
    static var autoShows: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.autoShows)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.autoShows)
        }
    }
    
    static var useAlwaysHideArea: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.useAlwaysHideArea)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.useAlwaysHideArea)
        }
    }
    
    static var startsWithMacos: Bool {
        get {
            return LaunchAtLogin.isEnabled
        }
        
        set(flag) {
            LaunchAtLogin.isEnabled = flag
        }
    }
    
    static var reduceAnimation: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.reduceAnimation)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.reduceAnimation)
        }
    }
    
}
