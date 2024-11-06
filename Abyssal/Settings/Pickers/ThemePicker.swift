//
//  ThemePicker.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/25.
//

import SwiftUI
import Defaults
import Luminare

struct ThemePicker: View {
    @Default(.theme) private var theme
    
    var body: some View {
        LuminarePopover(arrowEdge: .leading) {
            Text(
"""
Some themes will hide the icons inside the separators automatically, while others not.

Themes that automatically hide the icons will only show them when the status items inside the **Hide Area** are manually set to visible, while other themes indicate this by reducing the separators' opacity.
"""
            )
            .simpleTextFormat()
        } badge: {
            LuminareCompose("Theme", reducesTrailingSpace: true) {
                LuminareCompactPicker(selection: $theme)  {
                    ForEach(Theme.themes, id: \.self) { theme in
                        HStack {
                            Image(nsImage: theme.icon.image)
                            Text(theme.name)
                        }
                    }
                }
                .onChange(of: theme) { _, _ in
                    AbyssalApp.statusBarController.function()
                }
            }
        }
    }
}

#Preview {
    LuminareSection {
        ThemePicker()
    }
    .padding()
}
