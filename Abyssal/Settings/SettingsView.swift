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
                Spacer()
                
                VStack {
                    Text(Bundle.main.appName)
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
                .defaultScrollAnchor(.bottom)
                .padding(.top, -20)
#if DEBUG
                .border(.orange)
#endif
            }
            .frame(maxWidth: 375)
            
            VStack(spacing: 0) {
                SettingsTrafficsView()
                    .padding(20)
                
                Form {
                    SettingsGeneralSection()
                }
                .defaultScrollAnchor(.bottom)
                .padding(.top, -20)
#if DEBUG
                .border(.blue)
#endif
            }
            .frame(maxWidth: 425)
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}

#Preview {
    SettingsView()
}
