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
        
        static let MODIFIERS: String = "Modifiers"
        
        static let TIMEOUT: String = "Timeout"
        
        static let TIPS: String = "Tips"
        
        
        
        static let THEME: String = "Theme"
        
        
        
        static let SEPS_ORDER: 			String = "SepsOrder"
        
        static let FEEDBACK_INTENSITY: 	String = "FeedbackIntensity"
        
        
        
        static let COLLAPSED: String = "Collapsed"
        
        
        
        static let AUTO_SHOWS:			String = "AutoShows"
        
        static let USE_ALWAYS_HIDE_AREA: String = "AlwaysHide"
        
        static let REDUCE_ANIMATION: 	String = "ReduceAnimation"
        
    }
    
    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [Keys.MODIFIERS: [true, true, false]])
        UserDefaults.standard.register(defaults: [Keys.TIMEOUT: 3])
        UserDefaults.standard.register(defaults: [Keys.TIPS: true])

        UserDefaults.standard.register(defaults: [Keys.THEME: Themes.abyssal.name])
        
        UserDefaults.standard.register(defaults: [Keys.SEPS_ORDER: [0, 1, 2]])
        UserDefaults.standard.register(defaults: [Keys.FEEDBACK_INTENSITY: 0])
        
        UserDefaults.standard.register(defaults: [Keys.COLLAPSED: false])
        
        UserDefaults.standard.register(defaults: [Keys.AUTO_SHOWS: true])
        UserDefaults.standard.register(defaults: [Keys.USE_ALWAYS_HIDE_AREA: true])
        UserDefaults.standard.register(defaults: [Keys.REDUCE_ANIMATION: false])
    }
    
    static var modifiers: (control: Bool, option: Bool, command: Bool) {
        get {
            let defaultTuple = (control: true, option: true, command: true)
            
            if let array = UserDefaults.standard.array(forKey: Keys.MODIFIERS) as? [Bool] {
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
                forKey: Keys.MODIFIERS
            )
        }
    }
    
    static var timeout: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.TIMEOUT)
        }
        
        set(timeout) {
            UserDefaults.standard.set(
                timeout,
                forKey: Keys.TIMEOUT
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
            return UserDefaults.standard.bool(forKey: Keys.TIPS)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.TIPS)
        }
    }
    
    
    
    static var theme: Theme {
        get {
            let index = UserDefaults.standard.integer(forKey: Keys.THEME)
            
            guard index < Themes.themes.count else {
                return Themes.defaultTheme
            }
            
            return Themes.themes[index]
        }
        
        set(theme) {
            UserDefaults.standard.set(
                Themes.themes.firstIndex(of: theme),
                forKey: Keys.THEME
            )
        }
    }
    
    
    
    static var sepsOrder: [Int?]? {
        get {
            return UserDefaults.standard.array(
                forKey: Keys.SEPS_ORDER
            ) as? [Int?]
        }
        
        set(sepsOrder) {
            UserDefaults.standard.set(
                sepsOrder,
                forKey: Keys.SEPS_ORDER
            )
        }
    }
    
    static var feedbackIntensity: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.FEEDBACK_INTENSITY)
        }
        
        set(intensity) {
            UserDefaults.standard.set(intensity, forKey: Keys.FEEDBACK_INTENSITY)
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
                label: String(localized: "Hard", comment: "feedback intensity hard")
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
            return UserDefaults.standard.bool(forKey: Keys.COLLAPSED)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.COLLAPSED)
        }
    }
    
    
    
    static var autoShows: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.AUTO_SHOWS)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.AUTO_SHOWS)
        }
    }
    
    static var useAlwaysHideArea: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.USE_ALWAYS_HIDE_AREA)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.USE_ALWAYS_HIDE_AREA)
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
            return UserDefaults.standard.bool(forKey: Keys.REDUCE_ANIMATION)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.REDUCE_ANIMATION)
        }
    }
    
}
