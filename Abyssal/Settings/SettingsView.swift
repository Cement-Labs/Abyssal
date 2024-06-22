//
//  SettingsView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        HStack(spacing: -20) {
            VStack {
                Spacer()
                
                Text("Abyssal")
                    .font(.title)
                    .bold()
                    .padding(.vertical, 32)
                
                Spacer()
                
                Form {
                    SettingsModifiersSection()
                    
                    SettingsAdvancedSection()
                }
                .padding(.top, -20)
                .fixedSize()
#if DEBUG
                .overlay(.red.opacity(0.1))
#endif
            }
            
            VStack {
                SettingsTrafficsView()
                    .padding()
                
                Form {
                    SettingsGeneralSection()
                }
                .padding(.top, -20)
                .fixedSize()
#if DEBUG
                .overlay(.green.opacity(0.1))
#endif
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}

#Preview {
    SettingsView()
}
