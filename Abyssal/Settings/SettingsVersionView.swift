//
//  SettingsVersionView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI

struct SettingsVersionView: View {
    var body: some View {
        HStack {
            ProgressView()
                .controlSize(.small)
            
            Button {
                
            } label: {
                Image(systemSymbol: .shiftFill)
                
                let version = (false ? Text(Bundle.main.appVersion) : Text("\(Bundle.main.appVersion) \(Image(systemSymbol: .arrowRight)) \(Bundle.main.appVersion)"))
                    .monospaced()
                
                Text("Version \(version)")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)
        }
        .frame(height: 24)
    }
}

#Preview {
    SettingsVersionView()
        .padding()
}
