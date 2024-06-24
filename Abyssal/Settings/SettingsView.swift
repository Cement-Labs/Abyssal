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
            VStack(spacing: 0) {
                EmptyFormWrapper(normalizePadding: false) {
                    VStack {
                        Text(Bundle.main.appName)
                            .font(.title)
                            .bold()
                            .padding(8)
                        
                        SettingsVersionView()
                    }
                    .padding(.vertical, 42)
                }
                .defaultScrollAnchor(.bottom)
                
                Form {
                    SettingsModifiersSection()
                    
                    SettingsAdvancedSection()
                }
                .defaultScrollAnchor(.bottom)
#if DEBUG
                .border(.orange.opacity(0.1))
#endif
            }
            .frame(maxWidth: 325)
            
            VStack(spacing: 0) {
                SettingsTrafficsView()
                    .padding(20)
                
                Form {
                    SettingsGeneralSection()
                    
                    SettingsFunctionsSection()
                    
                    SettingsBehaviorsSection()
                }
                .defaultScrollAnchor(.bottom)
                .padding(.top, -20)
#if DEBUG
                .border(.blue.opacity(0.1))
#endif
            }
            .frame(maxWidth: 375)
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}

#Preview {
    SettingsView()
}
