//
//  CollapseStrategyControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct CollapseStrategyControl: View {
    @Default(.collapseStrategy) private var collapseStrategy
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Collapse Strategy")
            
            Spacer()
            
            Menu {
                Section("On Change") {
                    Toggle("Frontmost Application", isOn: $collapseStrategy.frontmostAppChange)
                    
                    Toggle("Screen", isOn: $collapseStrategy.screenChange)
                }
                
                Section("On Invalidation") {
                    Toggle("Menu Bar Cursor Interaction", isOn: $collapseStrategy.interactionInvalidate)
                }
            } label: {
                Text("Satisfying \(collapseStrategy.enabledCount) Rules")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    Form {
        CollapseStrategyControl()
    }
    .formStyle(.grouped)
}
