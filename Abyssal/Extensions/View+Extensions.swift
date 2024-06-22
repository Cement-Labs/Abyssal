//
//  View+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI

extension View {
    func `if`(
        _ condition: Bool,
        trueCase: (Self) -> Self,
        `else` falseCase: (Self) -> Self = { s in s }
    ) -> Self {
        if condition {
            trueCase(self)
        } else {
            falseCase(self)
        }
    }
    
    @ViewBuilder func ifSome(
        _ condition: Bool,
        trueCase: (Self) -> some View,
        `else` falseCase: (Self) -> some View
    ) -> some View {
        if condition {
            trueCase(self)
        } else {
            falseCase(self)
        }
    }
    
    @ViewBuilder func ifSome(
        _ condition: Bool,
        trueCase: (Self) -> some View
    ) -> some View {
        if condition {
            trueCase(self)
        }
    }
}
