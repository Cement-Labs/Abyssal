//
//  TimeFormat.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import Foundation

enum TimeFormat: DoubleFormattable {
    case second
    case minute
    
    static let instant = String(localized: "Instant")
    static let forever = String(localized: "Forever")
    
    var format: String {
        switch self {
        case .second:
            .init(localized: "%g Seconds")
        case .minute:
            .init(localized: "%g Minutes")
        }
    }
}
