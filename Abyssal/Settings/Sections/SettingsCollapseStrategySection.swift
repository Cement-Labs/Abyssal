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
            /*
            VStack(alignment: .leading) {
                Toggle("Frontmost application change", isOn: $collapseStrategy.frontmostAppChange)
                
                Toggle("Cursor interaction invalidate", isOn: $collapseStrategy.interactionInvalidate)
                
                Toggle("Screen change", isOn: $collapseStrategy.screenChange)
            }
            .toggleStyle(.checkbox)
             */
            
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
