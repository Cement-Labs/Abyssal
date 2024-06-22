//
//  SettingsView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        HStack(spacing: -10) {
            VStack {
                Spacer()
                
                Text("Abyssal")
                    .font(.title)
                    .bold()
                    .padding()
                
                Form {
                    SettingsModifiersSection()
                    
                    SettingsAdvancedSection()
                }
                .frame(minWidth: 300)
                .padding(.top, -20)
            }
            
            VStack {
                SettingsTrafficsView()
                    .padding()
                
                Form {
                    SettingsGeneralSection()
                }
                .padding(.top, -20)
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}

#Preview {
    SettingsView()
}
