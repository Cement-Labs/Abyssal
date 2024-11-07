//
//  MaxWidth.swift
//  Abyssal
//
//  Created by KrLite on 2024/11/5.
//

import SwiftUI

// mainly for correctly restricting max width in popovers
struct MaxWidth<Content>: View where Content: View {
    var maxWidth: CGFloat? = 480
    @ViewBuilder var content: () -> Content

    @State private var contentSize: CGSize = .zero
    @State private var containerSize: CGSize = .zero

    var body: some View {
        VStack {
            content()
                .frame(maxWidth: maxWidth)
                .fixedSize(horizontal: false, vertical: true)
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { size in
                    contentSize = size
                }
        }
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { size in
            containerSize = size
        }
        .frame(minWidth: contentSize.width, minHeight: contentSize.height)
    }
}

#Preview("Short") {
    MaxWidth {
        Text("Short")
    }
    .background(.red)
}

#Preview("Long") {
    MaxWidth {
        Text("""
Minim duis excepteur do eiusmod est officia consequat aute veniam qui excepteur Lorem. \
Quis pariatur dolore est irure deserunt adipisicing ex eu dolor minim sunt ullamco aliqua. \
Cupidatat ea cillum aute ad adipisicing dolor non non do nulla ea ullamco tempor amet. \
Voluptate in elit aliquip occaecat nulla esse quis enim officia consectetur nisi. \
Ad elit ut excepteur in est consectetur fugiat velit dolore. \
Aliquip dolore duis eiusmod Lorem duis duis adipisicing eu exercitation eiusmod ut eiusmod magna. \
Est deserunt occaecat exercitation quis qui deserunt.
""")
    }
    .background(.red)
}
