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
                
                Form {
                    SettingsModifierSection()
                    
                    SettingsAdvancedSection()
                    
                    SettingsCollapseStrategySection()
                }
                .padding(1)
                .defaultScrollAnchor(.bottom)
            }
            .frame(maxWidth: 370)
            
            VStack(spacing: 0) {
                SettingsTrafficsView()
                    .padding(20)
                
                Form {
                    SettingsGeneralSection()
                        .environment(\.hasTitle, false)
                    
                    SettingsFunctionsSection()
                    
                    SettingsBehaviorsSection()
                }
                .defaultScrollAnchor(.bottom)
                .padding(1)
                .padding(.top, -20)
            }
            .frame(maxWidth: 430)
        }
        .controlSize(.regular)
        .formStyle(.grouped)
        .scrollDisabled(true)
        .padding(.horizontal, -12) // Don't know why, but needed
    }
}

#Preview {
    SettingsView()
}
