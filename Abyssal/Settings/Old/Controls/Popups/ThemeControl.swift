//
//  ThemeControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct ThemeControl: View {
    @Default(.theme) private var theme
    @Default(.reduceAnimationEnabled) private var reduceAnimationEnabled
    
    var body: some View {
        TipWrapper(tip: themeTip) { tip in
            Picker("Theme", selection: $theme) {
                ForEach(Theme.themes, id: \.self) { theme in
                    HStack {
                        Image(nsImage: theme.icon.image)
                        Text(theme.name)
                    }
                }
            }
            .onChange(of: theme) { _, _ in
                AppDelegate.shared?.statusBarController.function()
            }
        }
        
        TipWrapper(tip: reduceAnimationTip) { tip in
            Toggle("Reduce animation", isOn: $reduceAnimationEnabled)
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

#Preview {
    Form {
        ThemeControl()
    }
    .formStyle(.grouped)
}
