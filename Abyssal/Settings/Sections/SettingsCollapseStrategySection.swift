//
//  SettingsCollapseStrategySection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct SettingsCollapseStrategySection: View {
    @Default(.collapseStrategy) private var collapseStrategy
    
    @Environment(\.hasTitle) private var hasTitle
    
    var body: some View {
        Section {
            SpacingVStack {
                Toggle("Frontmost application change", isOn: $collapseStrategy.frontmostAppChange)
                
                Toggle("Cursor interaction invalidate", isOn: $collapseStrategy.interactionInvalidate)
                
                Toggle("Screen change", isOn: $collapseStrategy.screenChange)
            }
            .toggleStyle(.checkbox)
        } header: {
            if hasTitle {
                Text("Collapse Strategy")
            }
        }
    }
}

#Preview {
    Form {
        SettingsCollapseStrategySection()
    }
    .formStyle(.grouped)
}
