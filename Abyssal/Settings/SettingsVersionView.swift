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
    
    @State var hasUpdate: Bool = false
    @State var fetchState: VersionManager.FetchState = .initialized
    
    var body: some View {
        TipWrapper(tip: updateTip) { tip in
            HStack {
                if fetchState == .fetching {
                    ProgressView()
                        .controlSize(.small)
                }
                
                Button {
                    VersionManager.fetchLatest()
                } label: {
                    if fetchState == .failed {
                        Image(systemSymbol: .exclamationmarkCircleFill)
                    } else if hasUpdate {
                        Image(systemSymbol: .shiftFill)
                    }
                    
                    let version = hasUpdate
                    ? Text("\(Bundle.main.appVersion) \(Image(systemSymbol: .arrowRight)) \(Version.remote.string)")
                    : Text(Bundle.main.appVersion)
                    
                    Text("Version \(version.monospaced())")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .foregroundStyle(fetchState == .failed
                                 ? AnyShapeStyle(.red)
                                 : hasUpdate
                                 ? AnyShapeStyle(.tint)
                                 : AnyShapeStyle(.placeholder)
                )
                .disabled(!fetchState.idle)
                
                .onChange(of: Version.hasUpdate, initial: true) { _, hasUpdate in
                    self.hasUpdate = hasUpdate
                }
                .onChange(of: VersionManager.fetchState, initial: true) { _, fetchState in
                    self.fetchState = fetchState
                }
                .onChange(of: fetchState) { _, _ in
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
