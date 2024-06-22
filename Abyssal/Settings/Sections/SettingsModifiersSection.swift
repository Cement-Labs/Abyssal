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
        VStack {
            HStack {
                Toggle(isOn: $modifiers.control) {
                    Image(systemSymbol: .control)
                        .frame(maxWidth: .infinity)
                }
                
                Toggle(isOn: $modifiers.option) {
                    Image(systemSymbol: .option)
                        .frame(maxWidth: .infinity)
                }
                
                Toggle(isOn: $modifiers.command) {
                    Image(systemSymbol: .command)
                        .frame(maxWidth: .infinity)
                }
            }
            .bold()
            .toggleStyle(.button)
            .buttonStyle(.borderless)
            .controlSize(.large)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("Press")
                    .fixedSize()
                
                Picker(selection: $modifierMode) {
                    ForEach(ModifiersAttribute.Mode.allCases, id: \.self) { mode in
                        switch mode {
                        case .all: Text("all")
                        case .any: Text("any")
                        }
                    }
                } label: {
                    EmptyView()
                }
                .buttonStyle(.accessoryBar)
                
                Text("to trigger")
                    .fixedSize()
            }
            .padding(.bottom, -4)
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThickMaterial)
                .stroke(.separator, style: .init(lineWidth: 1))
        }
    }
}

#Preview {
    SettingsModifiersSection()
        .padding()
}
