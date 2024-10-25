//
//  ThemePopup.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/25.
//

import SwiftUI
import Defaults
import Luminare

struct ThemePopup: View {
    @Default(.theme) private var theme
    @Default(.reduceAnimationEnabled) private var reduceAnimationEnabled
    
    var body: some View {
        TipWrapper(tip: themeTip) { tip in
            LuminareCompactPicker(elements: Theme.themes, selection: $theme) { theme in
                HStack {
                    Image(nsImage: theme.icon.image)
                    Text(theme.name)
                }
            } label: {
                Text("Theme")
            }
            .onChange(of: theme) { _, _ in
                AbyssalApp.statusBarController.function()
            }
        }
        
        TipWrapper(tip: reduceAnimationTip) { tip in
            LuminareToggle("Reduce animation", isOn: $reduceAnimationEnabled)
        }
    }
    
    private let themeTip = Tip {
        .init(localized: """
Some themes will hide the icons inside the separators automatically, while others not.

Themes that automatically hide the icons will only show them when the status items inside the **Hide Area** are manually set to visible, while other themes indicate this by reducing the separators' opacity.
""")
    }
    
    private let reduceAnimationTip = Tip {
        .init(localized: """
Reduce animation to gain a more performant experience.
""")
    }
}
