//
//  EmptyFormWrapper.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI

struct EmptyFormWrapper<Content>: View where Content: View {
    var normalizePadding: Bool = true
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        Form {
            content()
        }
        .formStyle(.columns)
        .padding(0) // Otherwise the nested Form will cause layout to overflow
        .padding(.leading, normalizePadding ? -8 : 0)
    }
}
