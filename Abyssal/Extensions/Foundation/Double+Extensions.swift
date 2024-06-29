//
//  Double+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import Foundation

extension Double {
func rounded(digits: Int) -> Double {
    let multiplier = pow(10.0, Double(digits))
    return (self * multiplier).rounded() / multiplier
}
}
