//
//  SettingsView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        HStack {
            VStack {
                Text("Abyssal")
                    .font(.title)
                    .bold()
                    .padding()
                
                Form {
                    SettingsModifiersSection()
                    
                    SettingsAdvancedSection()
                }
            }
            
            VStack {
                SettingsTrafficsView()
                
                Form {
                    SettingsGeneralSection()
                }
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}

#Preview {
    SettingsView()
}
