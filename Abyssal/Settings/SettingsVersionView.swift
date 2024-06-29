//
//  SettingsVersionView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI

struct SettingsVersionView: View {
    private let updateTip = Tip(permanent: true) {
        switch VersionManager.fetchState {
        case .initialized, .finished:
            Version.hasUpdate
            ? String(localized: """
An update is available. Click to access the download page.
""")
            : String(localized: "Click to check for updates.")
        case .fetching:
            String(localized: "Fetching for latest version…")
        case .failed:
            String(localized: "Failed to fetch for latest version.")
        }
        
    }
    
    var body: some View {
        TipWrapper(tip: updateTip) { tip in
            HStack {
                if VersionManager.fetchState == .fetching {
                    ProgressView()
                        .controlSize(.small)
                }
                
                Button {
                    VersionManager.fetchLatest()
                } label: {
                    if VersionManager.fetchState == .failed {
                        Image(systemSymbol: .exclamationmarkCircleFill)
                    } else if Version.hasUpdate {
                        Image(systemSymbol: .shiftFill)
                    }
                    
                    let version = Version.hasUpdate
                    ? Text("\(Version.app.string) \(Image(systemSymbol: .arrowRight)) \(Version.remote.string)")
                    : Text(Version.app.string)
                    
                    Text("Version \(version.monospaced())")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .foregroundStyle(VersionManager.fetchState == .failed
                                 ? AnyShapeStyle(.red)
                                 : Version.hasUpdate
                                 ? AnyShapeStyle(.tint)
                                 : AnyShapeStyle(.placeholder)
                )
                .disabled(!VersionManager.fetchState.idle)
                .onChange(of: VersionManager.fetchState) { _, _ in
                    tip.update()
                }
                
#if DEBUG
                Button("Debug Fetch State") {
                    VersionManager.fetchState = switch VersionManager.fetchState {
                    case .initialized: .fetching
                    case .fetching: .finished
                    case .finished: .failed
                    case .failed: .initialized
                    }
                }
#endif
            }
            .frame(height: 24)
        }
    }
}

#Preview {
    SettingsVersionView()
        .padding()
}
