//
//  UnitFormat.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import Foundation

enum UnitFormat: DoubleFormattable {
    case percentage
    case pixel
    
    var format: String {
        switch self {
        case .percentage:
            .init(localized: "%g%%")
        case .pixel:
            .init(localized: "%g Pixels")
        }
    }
}
