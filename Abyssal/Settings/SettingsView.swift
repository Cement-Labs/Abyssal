//
//  SettingsView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/21.
//

import SwiftUI
import SwiftUIIntrospect

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
#if DEBUG
                .border(.green.opacity(0.1))
#endif
                
                Form {
                    SettingsModifiersSection()
                    
                    SettingsAdvancedSection()
                }
                .padding(1)
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
                .padding(1)
                .padding(.top, -20)
#if DEBUG
                .border(.blue.opacity(0.1))
#endif
            }
            .frame(maxWidth: 375)
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
        .padding(.horizontal, -12) // Don't know why, but needed
    }
}

#Preview {
    SettingsView()
}
