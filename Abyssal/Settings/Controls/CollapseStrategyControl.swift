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
            Text("Collapses again")
            
            Spacer()
            
            Menu {
                Section("On Change") {
                    Toggle("Frontmost Application", isOn: $collapseStrategy.frontmostAppChange)
                    
                    Toggle("Main Screen", isOn: $collapseStrategy.screenChange)
                }
                
                Section("On Invalidation") {
                    Toggle("Menu Bar Interaction", isOn: $collapseStrategy.interactionInvalidate)
                }
            } label: {
                Text("When Satisfying Any of the \(collapseStrategy.enabledCount) Rules")
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
