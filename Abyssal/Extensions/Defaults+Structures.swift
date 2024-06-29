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
    enum Mode: String, CaseIterable, Codable, Defaults.Serializable {
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
    
    case forever = 0
    
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
    static let rangePercentage = 0.0...0.75
    static var rangePixel: ClosedRange<Double> {
        0...ScreenManager.width
    }
    
    case percentage(Double)
    case pixel(UInt64)
    
    var double: Double {
        get {
            switch self {
            case .percentage(let percentage):
                percentage
            case .pixel(let pixel):
                Double(pixel)
            }
        }
        
        set(double) {
            switch self {
            case .percentage(_):
                self = .percentage(double)
            case .pixel(_):
                self = .pixel(.init(double))
            }
        }
    }
    
    var range: ClosedRange<Double> {
        switch self {
        case .percentage(_):
            Self.rangePercentage
        case .pixel(_):
            Self.rangePixel
        }
    }
}
