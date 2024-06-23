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
        Section("Modifiers") {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Box(isOn: $modifiers.control, behavior: .toggle) {
                        Image(systemSymbol: .control)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Box(isOn: $modifiers.option, behavior: .toggle) {
                        Image(systemSymbol: .option)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Box(isOn: $modifiers.command, behavior: .toggle) {
                        Image(systemSymbol: .command)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(height: 32)
                .bold()
                .controlSize(.large)
                
                HStack {
                    // Use a column styled Form to diminish the Picker's empty label
                    EmptyFormWrapper(normalizePadding: false) {
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
                            
                            Text("of the above to trigger")
                                .fixedSize()
                        }
                        .foregroundStyle(.placeholder)
                    }
                    .fixedSize()
                    
                    Spacer()
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

#Preview {
    Form {
        SettingsModifiersSection()
    }
    .formStyle(.grouped)
}
