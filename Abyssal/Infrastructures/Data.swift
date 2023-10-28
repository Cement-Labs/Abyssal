//
//  Data.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/14.
//

import AppKit
import LaunchAtLogin

struct Data {
    
    enum Key: String {
        
        case collapsed = "Collapsed"
        
        
        
        case modifiers = "Modifiers"
        
        case timeout = "Timeout"
        
        case tips = "Tips"
        
        
        
        case theme = "Theme"
        
        case autoShows = "AutoShows"
        
        case feedbackIntensity = "FeedbackIntensity"
        
        case deadZone = "DeadZone"
        
        
        
        case useAlwaysHideArea = "AlwaysHide"
        
        case reduceAnimation = "ReduceAnimation"
        
        func register(
            _ value: Any
        ) {
            UserDefaults.standard.register(defaults: [rawValue: value])
        }
        
        func set(
            _ value: Any?
        ) {
            UserDefaults.standard.set(value, forKey: rawValue)
        }
        
        func array() -> [Any]? {
            UserDefaults.standard.array(forKey: rawValue)
        }
        
        func bool() -> Bool {
            UserDefaults.standard.bool(forKey: rawValue)
        }
        
        func integer() -> Int {
            UserDefaults.standard.integer(forKey: rawValue)
        }
        
        func float() -> Float {
            UserDefaults.standard.float(forKey: rawValue)
        }
        
    }
    
    static func registerDefaults() {
        Key.collapsed.register(false)
        
        Key.modifiers.register([false, true, true])
        Key.timeout.register(3)
        Key.tips.register(true)

        Key.theme.register(Themes.abyssal.name)
        Key.autoShows.register(true)
        Key.feedbackIntensity.register(0)
        Key.deadZone.register(0.25)
        
        Key.useAlwaysHideArea.register(true)
        Key.reduceAnimation.register(false)
    }
    
    static var collapsed: Bool {
        get {
            Key.collapsed.bool()
        }
        
        set(flag) {
            Key.collapsed.set(flag)
        }
    }
    
    static var modifiers: (control: Bool, option: Bool, command: Bool) {
        get {
            let defaultTuple = (control: false, option: true, command: true)
            
            if let array = Key.modifiers.array() as? [Bool] {
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
            Key.modifiers.set([modifiers.control, modifiers.option, modifiers.command])
        }
    }
    
    static var timeout: Int {
        get {
            Key.timeout.integer()
        }
        
        set(timeout) {
            Key.timeout.set(timeout)
        }
    }
    
    static let timeoutTickMarks = 11
    
    static var timeoutAttribute: (attr: Int?, label: String) {
        switch timeout {
        case 0:
            return (
                attr: 5,
                label: Localizations.FormattedTime.inSeconds(5)
            )
        case 1:
            return (
                attr: 10, 
                label: Localizations.FormattedTime.inSeconds(10)
            )
        case 2:
            return (
                attr: 15, 
                label: Localizations.FormattedTime.inSeconds(15)
            )
        case 3:
            return (
                attr: 30, 
                label: Localizations.FormattedTime.inSeconds(30)
            )
        case 4:
            return (
                attr: 45, 
                label: Localizations.FormattedTime.inSeconds(45)
            )
        case 5:
            return (
                attr: 60, 
                label: Localizations.FormattedTime.inMinutes(1)
            )
        case 6:
            return (
                attr: 60 * 2, 
                label: Localizations.FormattedTime.inMinutes(2)
            )
        case 7:
            return (
                attr: 60 * 3, 
                label: Localizations.FormattedTime.inMinutes(3)
            )
        case 8:
            return (
                attr: 60 * 5, 
                label: Localizations.FormattedTime.inMinutes(5)
            )
        case 9:
            return (
                attr: 60 * 10, 
                label: Localizations.FormattedTime.inMinutes(10)
            )
        default:
            return (
                attr: nil,
                label: Localizations.FormattedTime.forever)
        }
    }
    
    static var startsWithMacos: Bool {
        get {
            LaunchAtLogin.isEnabled
        }
        
        set(flag) {
            LaunchAtLogin.isEnabled = flag
        }
    }
    
    
    
    static var tips: Bool {
        get {
            Key.tips.bool()
        }
        
        set(flag) {
            Key.tips.set(flag)
        }
    }
    
    
    
    static var theme: Theme {
        get {
            let index = Key.theme.integer()
            
            guard index < Themes.themes.count else {
                return Themes.defaultTheme
            }
            
            return Themes.themes[index]
        }
        
        set(theme) {
            Key.theme.set(Themes.themes.firstIndex(of: theme))
        }
    }
    
    static var autoShows: Bool {
        get {
            Key.autoShows.bool()
        }
        
        set(flag) {
            Key.autoShows.set(flag)
        }
    }
    
    static var feedbackIntensity: Int {
        get {
            Key.feedbackIntensity.integer()
        }
        
        set(intensity) {
            Key.feedbackIntensity.set(intensity)
        }
    }
    
    static let feedbackIntensityTickMarks = 4
    
    static var feedbackAttribute: (feedback: [NSHapticFeedbackManager.FeedbackPattern?], label: String) {
        switch feedbackIntensity {
        case 1:
            return (
                feedback: [.levelChange],
                label: Localizations.FeedbackIntensity.light
            )
        case 2:
            return (
                feedback: [.generic, nil, .alignment],
                label: Localizations.FeedbackIntensity.medium
            )
        case 3:
            return (
                feedback: [.levelChange, .alignment, .alignment, nil, nil, nil, .levelChange],
                label: Localizations.FeedbackIntensity.heavy
            )
        default:
            return (
                feedback: [],
                label: Localizations.FeedbackIntensity.disabled
            )
        }
    }
    
    static var deadZone: CGFloat {
        get {
            CGFloat(Key.deadZone.float())
        }
        
        set(deadZone) {
            Key.deadZone.set(deadZone)
        }
    }
    
    static var deadZonePercentage: String {
        String(format: "%d%%", Int(deadZone * 100))
    }
    
    
    
    static var useAlwaysHideArea: Bool {
        get {
            Key.useAlwaysHideArea.bool()
        }
        
        set(flag) {
            Key.useAlwaysHideArea.set(flag)
        }
    }
    
    static var reduceAnimation: Bool {
        get {
            Key.reduceAnimation.bool()
        }
        
        set(flag) {
            Key.reduceAnimation.set(flag)
        }
    }
    
}
