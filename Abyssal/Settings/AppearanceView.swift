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
            ThemePopup()
        }
    }
}

#Preview {
    AppearanceView()
}
