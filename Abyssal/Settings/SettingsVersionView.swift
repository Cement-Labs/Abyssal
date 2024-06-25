//
//  SettingsVersionView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI

struct SettingsVersionView: View {
    private let updateTip = Tip(permanent: true) {
        Version.hasUpdate ? .init(localized: """
An update is available. Click to access the download page.
""") : .init(localized: "Click to check for updates.")
    }
    
    var body: some View {
        TipWrapper(tip: updateTip) { tip in
            HStack {
                ProgressView()
                    .controlSize(.small)
                
                Button {
                    VersionManager.fetchLatest()
                } label: {
                    Image(systemSymbol: .shiftFill)
                    
                    let version = (false ? Text(Version.app.string) : Text("\(Version.app.string) \(Image(systemSymbol: .arrowRight)) \(Version.remote.string)"))
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
}

#Preview {
    SettingsVersionView()
        .padding()
}
