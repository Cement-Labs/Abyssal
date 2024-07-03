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
                    ModifierSection()
                    
                    ShortcutsSection()
                    
                    AdvancedSection()
                }
                .padding(1)
                .defaultScrollAnchor(.bottom)
            }
            .frame(width: 400)
            
            VStack(spacing: 0) {
                SettingsTrafficsView()
                    .padding(20)
                
                Form {
                    GeneralSection()
                        .environment(\.hasTitle, false)
                    
                    FunctionsSection()
                    
                    BehaviorsSection()
                }
                .defaultScrollAnchor(.bottom)
                .padding(1)
                .padding(.top, -20)
            }
            .frame(width: 450)
        }
        .controlSize(.regular)
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}

#Preview {
    SettingsView()
        .frame(minHeight: 800)
}
