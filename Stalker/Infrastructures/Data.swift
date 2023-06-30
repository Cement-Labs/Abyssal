//
//  Data.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import AppKit
import LaunchAtLogin

public enum Data {
    
    public class Keys {
        
        static let THEME: String = "theme"
        
        public static let SEPS_ORDER: 			String = "sepsOrder"
        
        public static let FEEDBACK_INTENSITY: 	String = "feedbackIntensity"
        
        // MARK: - Booleans
        
        public static let COLLAPSED: String = "collapsed"
        
        
        
        public static let AUTO_SHOWS:			String = "autoShows"
        
        public static let USE_ALWAYS_HIDE_AREA: String = "alwaysHide"
        
        public static let REDUCE_ANIMATION: 	String = "reduceAnimation"
        
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
            return [.levelChange, .generic]
        case 2:
            return [.generic, nil, nil, .levelChange, .alignment]
        case 3:
            return [.generic, .generic, nil, nil, nil, nil, nil, .levelChange, .alignment]
        default:
            return []
        }
    }
    
    
    
    public static var autoShows: 					Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.AUTO_SHOWS)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.AUTO_SHOWS)
        }
    }
    
    public static var useAlwaysHideArea: 			Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.USE_ALWAYS_HIDE_AREA)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.USE_ALWAYS_HIDE_AREA)
        }
    }
    
    public static var startsWithMacos: 				Bool {
        get {
            return LaunchAtLogin.isEnabled
        }
        
        set(flag) {
            LaunchAtLogin.isEnabled = flag
        }
    }
    
    public static var reduceAnimation: 				Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.REDUCE_ANIMATION)
        }
        
        set(flag) {
            UserDefaults.standard.set(flag, forKey: Keys.REDUCE_ANIMATION)
        }
    }
    
}
