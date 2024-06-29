//
//  SpacingVStack.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI

struct SpacingVStack<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            content()
        }
    }
}
