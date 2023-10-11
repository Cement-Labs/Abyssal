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
        
        public static let THEME: String = "Theme"
        
        
        
        public static let SEPS_ORDER: 			String = "SepsOrder"
        
        public static let FEEDBACK_INTENSITY: 	String = "FeedbackIntensity"
        
        
        
        public static let COLLAPSED: String = "Collapsed"
        
        
        
        public static let AUTO_SHOWS:			String = "AutoShows"
        
        public static let USE_ALWAYS_HIDE_AREA: String = "AlwaysHide"
        
        public static let REDUCE_ANIMATION: 	String = "ReduceAnimation"
        
    }
    
    public static func registerDefaults() {
        UserDefaults.standard.register(defaults: [Keys.THEME: Themes.abyssal.name])
        
        UserDefaults.standard.register(defaults: [Keys.SEPS_ORDER: [0, 1, 2]])
        UserDefaults.standard.register(defaults: [Keys.FEEDBACK_INTENSITY: 0])
        
        UserDefaults.standard.register(defaults: [Keys.COLLAPSED: false])
        
        UserDefaults.standard.register(defaults: [Keys.AUTO_SHOWS: true])
        UserDefaults.standard.register(defaults: [Keys.USE_ALWAYS_HIDE_AREA: true])
        UserDefaults.standard.register(defaults: [Keys.REDUCE_ANIMATION: false])
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
    
    
    
    public static var collapsed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.COLLAPSED)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.COLLAPSED)
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
    
    public static var feedbackAttributes: [NSHapticFeedbackManager.FeedbackPattern?] {
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
