//
//  ComposedTip.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import SwiftUI
import Defaults

struct ComposedTip<Title, Content>: View where Title: View, Content: View {
    @Default(.tipsEnabled) var tipsEnabled
    
    @ViewBuilder var content: () -> Content
    @ViewBuilder var title: () -> Title
    
    var body: some View {
        SimpleTip {
            VStack {
                title()
                    .font(.title3)
                    .bold()
                
                if tipsEnabled {
                    content()
                }
            }
        }
    }
}
