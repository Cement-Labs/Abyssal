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
                
                VStack {
                    Text("Abyssal")
                        .font(.title)
                        .bold()
                        .padding(8)
                    
                    SettingsVersionView()
                }
                .padding(.vertical, 32)
                
                Spacer()
                
                Form {
                    SettingsModifiersSection()
                    
                    SettingsAdvancedSection()
                }
                .padding(.top, -20)
                .fixedSize()
#if DEBUG
                .border(.red)
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
                .border(.green)
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
