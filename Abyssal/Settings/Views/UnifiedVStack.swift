//
//  UnifiedVStack.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI

struct UnifiedVStack<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 21) {
            content()
        }
    }
}
