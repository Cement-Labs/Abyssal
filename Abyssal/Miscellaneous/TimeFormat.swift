//
//  TimeFormat.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import Foundation

struct TimeFormat {
    static let second = String(localized: "%g Seconds")
    static let minute = String(localized: "%g Minutes")
    static let forever = String(localized: "Forever")
    
    static func inSeconds(_ number: Double) -> String {
        String(format: second, number)
    }
    
    static func inMinutes(_ number: Double) -> String {
        String(format: minute, number)
    }
}
