//
//  Data.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/14.
//

import AppKit
import LaunchAtLogin

public enum Data {
    
    public class Keys {

        public static let MODIFIERS: String = "Modifiers"

        public static let TIMEOUT: String = "Timeout"


        
        public static let THEME: String = "Theme"
        
        
        
        public static let SEPS_ORDER: 			String = "SepsOrder"
        
        public static let FEEDBACK_INTENSITY: 	String = "FeedbackIntensity"
        
        
        
        public static let COLLAPSED: String = "Collapsed"
        
        
        
        public static let AUTO_SHOWS:			String = "AutoShows"
        
        public static let USE_ALWAYS_HIDE_AREA: String = "AlwaysHide"
        
        public static let REDUCE_ANIMATION: 	String = "ReduceAnimation"
        
    }
    
    public static func registerDefaults() {
        UserDefaults.standard.register(defaults: [Keys.MODIFIERS: [true, true, false]])
        UserDefaults.standard.register(defaults: [Keys.TIMEOUT: 3])

        UserDefaults.standard.register(defaults: [Keys.THEME: Themes.abyssal.name])
        
        UserDefaults.standard.register(defaults: [Keys.SEPS_ORDER: [0, 1, 2]])
        UserDefaults.standard.register(defaults: [Keys.FEEDBACK_INTENSITY: 0])
        
        UserDefaults.standard.register(defaults: [Keys.COLLAPSED: false])
        
        UserDefaults.standard.register(defaults: [Keys.AUTO_SHOWS: true])
        UserDefaults.standard.register(defaults: [Keys.USE_ALWAYS_HIDE_AREA: true])
        UserDefaults.standard.register(defaults: [Keys.REDUCE_ANIMATION: false])
    }
    
    static var modifiers: (option: Bool, command: Bool, shift: Bool) {
        get {
            let defaultTuple = (option: true, command: true, shift: false)
            
            if let array = UserDefaults.standard.array(forKey: Keys.MODIFIERS) as? [Bool] {
                guard array.count == Mirror(reflecting: defaultTuple).children.count
                else {
                    return defaultTuple
                }
                        
                return (option: array[0], command: array[1], shift: array[2])
            } else {
                return defaultTuple
            }
        }
        
        set(modifiers) {
            UserDefaults.standard.set(
                [modifiers.option, modifiers.command, modifiers.shift],
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
    
    
    
    static var theme: Themes.Theme {
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
    
    
    
    public static var sepsOrder: [Int?]? {
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
    
    public static var feedbackIntensity: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.FEEDBACK_INTENSITY)
        }
        
        set(intensity) {
            UserDefaults.standard.set(intensity, forKey: Keys.FEEDBACK_INTENSITY)
        }
    }
    
    public static let feedbackIntensityTickMarks: Int = 4
    
    public static var feedbackAttribute: [NSHapticFeedbackManager.FeedbackPattern?] {
        switch feedbackIntensity {
        case 1:
            return [.levelChange]
        case 2:
            return [.generic, nil, nil, .alignment]
        case 3:
            return [.levelChange, .alignment, nil, nil, nil, nil, .levelChange]
        default:
            return []
        }
    }
    
    
    
    public static var collapsed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.COLLAPSED)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.COLLAPSED)
        }
    }
    
    
    
    public static var autoShows: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.AUTO_SHOWS)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.AUTO_SHOWS)
        }
    }
    
    public static var useAlwaysHideArea: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.USE_ALWAYS_HIDE_AREA)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.USE_ALWAYS_HIDE_AREA)
        }
    }
    
    public static var startsWithMacos: Bool {
        get {
            return LaunchAtLogin.isEnabled
        }
        
        set(flag) {
            LaunchAtLogin.isEnabled = flag
        }
    }
    
    public static var reduceAnimation: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.REDUCE_ANIMATION)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.REDUCE_ANIMATION)
        }
    }
    
}
