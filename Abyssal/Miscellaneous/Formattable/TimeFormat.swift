//
//  TimeFormat.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import Foundation

enum TimeFormat: Formattable {
    typealias Value = Double
    
    case second
    case minute
    
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
