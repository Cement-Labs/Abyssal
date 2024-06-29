//
//  Range+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import Foundation

extension Range where Bound: FloatingPoint {
    func percentage(_ value: Bound) -> Bound {
        let base = lowerBound
        let span = upperBound - lowerBound
        return (value - base) / span
    }
    
    func fromPercentage(_ percentage: Bound) -> Bound {
        let base = lowerBound
        let span = upperBound - lowerBound
        return percentage * span + base
    }
}

extension ClosedRange where Bound: FloatingPoint {
    func percentage(_ value: Bound) -> Bound {
        let base = lowerBound
        let span = upperBound - lowerBound
        return (value - base) / span
    }
    
    func fromPercentage(_ percentage: Bound) -> Bound {
        let base = lowerBound
        let span = upperBound - lowerBound
        return percentage * span + base
    }
}
