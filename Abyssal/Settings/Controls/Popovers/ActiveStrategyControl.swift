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
        TipWrapper(tip: activeStrategyTip) { tip in
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
    
    private let activeStrategyTip = Tip {
        .init(localized: """
The stratrgy used for automatically cancelling **Auto Idling.** When the condition is met, **\(Bundle.main.appName)** will recover the active state where menu bar items in both **Hide Area** and **Always Hide Area** become hidden.
""")
    }
}

#Preview {
    Form {
        ActiveStrategyControl()
    }
    .formStyle(.grouped)
}
