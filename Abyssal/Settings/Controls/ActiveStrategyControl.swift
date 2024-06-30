//
//  ActiveStrategyControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct ActiveStrategyControl: View {
    @Default(.screenSettings) private var screenSettings
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Becomes active again")
            
            Spacer()
            
            Menu {
                Section("On Change") {
                    Toggle("Frontmost Application", isOn: $screenSettings.main.activeStrategy.frontmostAppChange)
                    
                    Toggle("Main Screen", isOn: $screenSettings.main.activeStrategy.screenChange)
                }
                
                Section("On Invalidation") {
                    Toggle("Menu Bar Interaction", isOn: $screenSettings.main.activeStrategy.interactionInvalidate)
                }
            } label: {
                Text("When Satisfying Any of the \(screenSettings.main.activeStrategy.enabledCount) Rules")
            }
            .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
    Form {
        ActiveStrategyControl()
    }
    .formStyle(.grouped)
}
