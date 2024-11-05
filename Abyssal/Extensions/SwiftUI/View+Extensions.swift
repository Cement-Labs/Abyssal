//
//  View+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/25.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<T: View>(
        _ condition: Bool,
        ifTrue: @escaping (Self) -> T,
        ifFalse: ((Self) -> T)? = nil
    ) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse?(self)
        }
    }
    
    @ViewBuilder func ifLet<T: View, V>(
        _ conditionalValue: V?,
        ifTrue: @escaping (Self, V) -> T,
        ifFalse: ((Self) -> T)? = nil
    ) -> some View {
        if let v = conditionalValue {
            ifTrue(self, v)
        } else {
            ifFalse?(self)
        }
    }
    
    @ViewBuilder func simpleTextFormat(maxWidth: CGFloat? = 480) -> some View {
        MaxWidth(maxWidth: maxWidth) {
            self
                .multilineTextAlignment(.leading)
        }
        .padding()
    }
}
