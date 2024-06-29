//
//  CollapseStrategyControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct CollapseStrategyControl: View {
    @Default(.screenSettings) private var screenSettings
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Collapses again")
            
            Spacer()
            
            Menu {
                Section("On Change") {
                    Toggle("Frontmost Application", isOn: $screenSettings.main.collapseStrategy.frontmostAppChange)
                    
                    Toggle("Main Screen", isOn: $screenSettings.main.collapseStrategy.screenChange)
                }
                
                Section("On Invalidation") {
                    Toggle("Menu Bar Interaction", isOn: $screenSettings.main.collapseStrategy.interactionInvalidate)
                }
            } label: {
                Text("When Satisfying Any of the \(screenSettings.main.collapseStrategy.enabledCount) Rules")
            }
            .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    Form {
        CollapseStrategyControl()
    }
    .formStyle(.grouped)
}
