//
//  TipTitle.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import SwiftUI

struct TipTitle<Content, Value>: View where Content: View, Value: Equatable {
    @Binding var value: Value
    @ViewBuilder var content: () -> Content
    
    init(value: Binding<Value>, @ViewBuilder content: @escaping () -> Content) {
        self._value = value
        self.content = content
    }
    
    init(@ViewBuilder content: @escaping () -> Content) where Value == Bool {
        self.init(value: .constant(false), content: content)
    }
    
    init(_ titleKey: LocalizedStringKey, value: Binding<Value>) where Content == Text {
        self.init(value: value) {
            Text(titleKey)
        }
    }
    
    init(_ titleKey: LocalizedStringKey) where Content == Text, Value == Bool {
        self.init(titleKey, value: .constant(false))
    }
    
    var body: some View {
        content()
            .fixedSize()
            .font(.title3)
            .bold()
        
            .contentTransition(.numericText(countsDown: true))
            .animation(.smooth, value: value)
    }
}
