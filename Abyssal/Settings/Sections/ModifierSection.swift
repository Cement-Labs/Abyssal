//
//  ModifierSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI
import Defaults

struct ModifierSection: View {
    @Default(.modifier) private var modifiers
    @Default(.modifierCompose) private var modifierCompose
    
    @Environment(\.hasTitle) private var hasTitle
    
    private let modifierTip = Tip {
        .init(localized: """
The modifier keys to use for showing the **Always Hide Area.** It is recommended to keep `⌘` enabled.
""")
    }
    
    var body: some View {
        Section {
            VStack(spacing: 8) {
                TipWrapper(tip: modifierTip) { tip in
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
                }
                
                HStack {
                    // Use a column styled Form to diminish the Picker's empty label
                    EmptyFormWrapper(normalizePadding: false) {
                        HStack(alignment: .firstTextBaseline) {
                            Picker(selection: $modifierCompose) {
                                ForEach(Modifier.Compose.allCases, id: \.self) { mode in
                                    switch mode {
                                    case .all: Text("all")
                                    case .any: Text("any")
                                    }
                                }
                            } label: {
                                Text("[before modifier mode picker]")
                            }
                            
                            Text("[after modifier mode picker]")
                                .fixedSize()
                        }
                        .foregroundStyle(.placeholder)
                    }
                    .fixedSize()
                    
                    Spacer()
                }
                .padding(.horizontal, 2)
            }
        } header: {
            if hasTitle {
                Text("Modifier")
            }
        }
    }
}

#Preview {
    Form {
        ModifierSection()
    }
    .formStyle(.grouped)
}
