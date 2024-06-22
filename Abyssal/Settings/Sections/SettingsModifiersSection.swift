//
//  SettingsModifiersSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI
import Defaults

struct SettingsModifiersSection: View {
    @Default(.modifiers) var modifiers
    @Default(.modifierMode) var modifierMode
    
    var body: some View {
        Section {
            VStack {
                HStack(spacing: 8) {
                    Box(isOn: $modifiers.control, behavior: .toggle) {
                        Image(systemSymbol: .control)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .defaultStyles()
                    
                    Box(isOn: $modifiers.option, behavior: .toggle) {
                        Image(systemSymbol: .option)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .defaultStyles()
                    
                    Box(isOn: $modifiers.command, behavior: .toggle) {
                        Image(systemSymbol: .command)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .defaultStyles()
                }
                .frame(height: 32)
                .bold()
                .controlSize(.large)
                
                // Use a column styled Form to diminish the Picker's empty label
                Form {
                    HStack(alignment: .firstTextBaseline) {
                        Picker(selection: $modifierMode) {
                            ForEach(ModifiersAttribute.Mode.allCases, id: \.self) { mode in
                                switch mode {
                                case .all: Text("all")
                                case .any: Text("any")
                                }
                            }
                        } label: {
                            Text("Press")
                        }
                        .aspectRatio(contentMode: .fit)
                        
                        Text("key to trigger")
                        
                        Spacer()
                    }
                    .foregroundStyle(.secondary)
                    .padding(4)
                    .padding(.bottom, -8)
                }
                .formStyle(.columns)
            }
            .padding(8)
        }
    }
}

#Preview {
    Form {
        SettingsModifiersSection()
    }
    .formStyle(.grouped)
}
