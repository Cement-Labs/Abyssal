//
//  Bool+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import Foundation

extension Bool {
    static func &= (lhs: inout Bool, rhs: Bool) {
        lhs = lhs && rhs
    }
}
