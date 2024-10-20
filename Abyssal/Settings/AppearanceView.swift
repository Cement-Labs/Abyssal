//
//  AppearanceView.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/20.
//

import SwiftUI
import Luminare

struct AppearanceView: View {
    var body: some View {
        LuminareSection {
            TipWrapper(tip: ExampleTips.loremTitleContent()) { tip in
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    AppearanceView()
}
