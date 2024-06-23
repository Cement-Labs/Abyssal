//
//  SimpleTip.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI

struct SimpleTip<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .padding()
            .frame(maxWidth: 450)
            .fixedSize()
    }
}
