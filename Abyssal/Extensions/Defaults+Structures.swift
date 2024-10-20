//
//  Defaults+Structures.swift
//  Abyssal
//
//  Created by KrLite on 2024/2/8.
//

import Foundation
import Defaults
import AppKit
import SwiftUI

extension Theme: Defaults.Serializable {
    struct Bridge: Defaults.Bridge {
        typealias Value = Theme
        typealias Serializable = String
        
        func serialize(_ value: Theme?) -> String? {
            guard let value else {
                return nil
            }
            
            return value.id
        }
        
        func deserialize(_ object: String?) -> Theme? {
            guard
                let id = object,
                Theme.themeIds.contains(id)
            else {
                return nil
            }
            
            return Theme.themes.first { $0.id == id }
        }
    }
    
    static let bridge = Bridge()
}

struct Modifier: OptionSet, Defaults.Serializable {
    let rawValue: UInt8
    
    static let control  = Modifier(rawValue: 1 << 0)
    static let option   = Modifier(rawValue: 1 << 1)
    static let command  = Modifier(rawValue: 1 << 2)
    
    static let none:    Modifier = []
    static let all:     Modifier = [.control, .option, .command]
    
    var control: Bool {
        get {
            self.contains(.control)
        }
        
        set {
            if newValue {
                self.formUnion(.control)
            } else {
                self.remove(.control)
            }
        }
    }
    
    var option: Bool {
        get {
            self.contains(.option)
        }
        
        set {
            if newValue {
                self.formUnion(.option)
            } else {
                self.remove(.option)
            }
        }
    }
    
    var command: Bool {
        get {
            self.contains(.command)
        }
        
        set {
            if newValue {
                self.formUnion(.command)
            } else {
                self.remove(.command)
            }
        }
    }
    
    var flags: NSEvent.ModifierFlags {
        var result = NSEvent.ModifierFlags()
        
        if self.contains(.control) {
            result.formUnion(.control)
        }
        if self.contains(.option) {
            result.formUnion(.option)
        }
        if self.contains(.command) {
            result.formUnion(.command)
        }
        
        return result
    }
    
    static func fromFlags(_ flags: NSEvent.ModifierFlags) -> Modifier {
        var result = Modifier()
        
        if flags.contains(.control) {
            result.formUnion(.control)
        }
        if flags.contains(.option) {
            result.formUnion(.option)
        }
        if flags.contains(.command) {
            result.formUnion(.command)
        }
        
        return result
    }
}

extension Modifier {
    enum Compose: String, CaseIterable, Codable, Defaults.Serializable {
        case any = "any"
        case all = "all"
        
        func triggers(input: Modifier) -> Bool {
            switch self {
            case .any:
                // OK if the two sets have any member in common
                !Defaults[.modifier].isDisjoint(with: input)
            case .all:
                // OK if the input is a superset of the configured
                input.isSuperset(of: Defaults[.modifier])
            }
        }
    }
}

enum Timeout: Int, CaseIterable, Defaults.Serializable {
    case instant = 0
    
    case sec5   = 5
    case sec10  = 10
    case sec15  = 15
    case sec30  = 30
    case sec45  = 45
    case sec60  = 60
    
    case min2   = 120
    case min3   = 180
    case min5   = 300
    case min10  = 600
    
    case forever = -1
    
    var attribute: Int? {
        switch self {
        case .forever: nil
        default: self.rawValue
        }
    }
}

enum Feedback: Int, CaseIterable, Defaults.Serializable {
    case none   = 0
    case light  = 1
    case medium = 2
    case heavy  = 3
    
    var pattern: [NSHapticFeedbackManager.FeedbackPattern?] {
        switch self {
        case .light: [.levelChange]
        case .medium: [.generic, nil, .alignment]
        case .heavy: [.levelChange, .alignment, .alignment, nil, nil, nil, .levelChange]
            
        default: []
        }
    }
}

enum DeadZone: Codable, Defaults.Serializable {
    case percentage(Double)
    case pixel(Double)
    
    var range: ClosedRange<Double> {
        mode.range
    }
    
    var value: Double {
        get {
            switch self {
            case .percentage(let percentage):
                percentage
            case .pixel(let pixel):
                pixel
            }
        }
        
        set {
            self = mode.wrap(newValue)
        }
    }
    
    var sliderPercentage: Double {
        get {
            range.percentage(value)
        }
        
        set(percentage) {
            value = range.fromPercentage(percentage)
        }
    }
    
    var screenPixel: Double {
        switch self {
        case .percentage(_):
            Mode.pixel.range.percentage(sliderPercentage)
        case .pixel(let pixel):
            pixel
        }
    }
}

extension DeadZone {
    enum Mode: CaseIterable {
        case percentage
        case pixel
        
        var range: ClosedRange<Double> {
            switch self {
            case .percentage:
                0...75
            case .pixel:
                0...ScreenManager.width
            }
        }
        
        func wrap(_ value: Double) -> DeadZone {
            switch self {
            case .percentage:
                    .percentage(value)
            case .pixel:
                    .pixel(value)
            }
        }
        
        func from(_ deadZone: DeadZone) -> Double {
            guard self != deadZone.mode else {
                return deadZone.value
            }
            
            return switch self {
            case .percentage:
                switch deadZone {
                case .pixel(_):
                    deadZone.sliderPercentage * 100
                default: deadZone.value
                }
            case .pixel:
                switch deadZone {
                case .percentage(let percentage):
                    range.fromPercentage(percentage / 100)
                default: deadZone.value
                }
            }
        }
    }
    
    var mode: Mode {
        get {
            switch self {
            case .percentage(_):
                    .percentage
            case .pixel(_):
                    .pixel
            }
        }
        
        set(type) {
            guard type != self.mode else { return }
            
            self = type.wrap(type.from(self))
        }
    }
}

extension DeadZone: Equatable {
    
}

struct ActiveStrategy: Codable, Defaults.Serializable {
    /// When frontmost app changes
    var frontmostAppChange: Bool
    /// When cursor interaction invalidates in menus
    var interactionInvalidate: Bool
    /// When current screen changes
    var screenChange: Bool
    
    var values: [Bool] {
        [
            frontmostAppChange,
            interactionInvalidate,
            screenChange
        ]
    }
    
    var enabledCount: Int {
        values.count { $0 }
    }
}

struct ScreenSettings: Codable, Defaults.Serializable {
    struct Individual: Codable, Defaults.Serializable {
        var activeStrategy: ActiveStrategy
        var deadZone: DeadZone
        
        var respectNotch: Bool
    }
    
    var global: Individual
    var unique: [CGDirectDisplayID: Individual]
    
    var main: Individual {
        get {
            guard let id = ScreenManager.main?.displayID else {
                return global
            }
            
            return unique[id] ?? global
        }
        
        set(individual) {
            guard 
                let id = ScreenManager.main?.displayID,
                isMainUnique
            else {
                global = individual
                return
            }
            
            unique[id] = individual
        }
    }
    
    var isMainUnique: Bool {
        get {
            guard let id = ScreenManager.main?.displayID else {
                return false
            }
            
            return unique.keys.contains { $0 == id }
        }
        
        set(isUnique) {
            guard let id = ScreenManager.main?.displayID else {
                return
            }
            
            if isUnique {
                let encoder = JSONEncoder()
                let data = try? encoder.encode(global)
                if
                    let data,
                    let copied = try? JSONDecoder().decode(Individual.self, from: data)
                {
                    unique[id] = copied
                }
            } else {
                unique.removeValue(forKey: id)
            }
        }
    }
}

enum MenuBarOverride: CaseIterable, Codable, Defaults.Serializable {
    case app
    case empty
    
    var menu: NSMenu? {
        switch self {
        case .app:
            appMenu
        case .empty:
            emptyMenu
        }
    }
    
    func apply() {
        ApplicationMenuManager.apply(menu)
    }
}
