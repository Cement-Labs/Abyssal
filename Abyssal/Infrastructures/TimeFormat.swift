//
//  TimeFormat.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import Foundation

struct TimeFormat {
    static let second = NSLocalizedString("TimeFormat/Seconds", value: "%g Seconds", comment: "(Double) + Seconds")
    static let minute = NSLocalizedString("TimeFormat/Minutes", value: "%g Minutes", comment: "(Double) + Minutes")
    static let forever = NSLocalizedString("TimeFormat/Forever", value: "Forever", comment: "Forever")
    
    static func inSeconds(_ number: Double) -> String {
        String(format: second, number)
    }
    
    static func inMinutes(_ number: Double) -> String {
        String(format: minute, number)
    }
}
