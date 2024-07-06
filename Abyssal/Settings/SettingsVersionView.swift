//
//  SettingsVersionView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI

struct SettingsVersionView: View {
    private let updateTip = Tip(permanent: true) {
        switch VersionModel.shared.fetchState {
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
    
    @State private var versionModel = VersionModel.shared
    
    @Environment(\.openURL) private var openUrl
    
    var body: some View {
        TipWrapper(alwaysVisible: true, tip: updateTip) { tip in
            HStack {
                if versionModel.fetchState == .fetching {
                    ProgressView()
                        .controlSize(.small)
                }
                
                Button {
                    if versionModel.hasUpdate {
                        // Access the download page
                        openUrl(.release)
                    } else {
                        versionModel.fetchLatest()
                    }
                    
                    tip.hide()
                    tip.show(nil)
                } label: {
                    if versionModel.fetchState == .failed {
                        Image(systemSymbol: .exclamationmarkCircleFill)
                    } else if versionModel.hasUpdate {
                        Image(systemSymbol: .shiftFill)
                    }
                    
                    let version = versionModel.hasUpdate
                    ? Text("\(versionModel.app.string) \(Image(systemSymbol: .arrowRight)) \(versionModel.remote.string)")
                    : Text(versionModel.app.string)
                    
                    Text("Version \(version.monospaced())")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .foregroundStyle(versionModel.fetchState == .failed
                                 ? AnyShapeStyle(.red)
                                 : versionModel.hasUpdate
                                 ? AnyShapeStyle(.tint)
                                 : AnyShapeStyle(.placeholder)
                )
                .disabled(!versionModel.fetchState.idle)
                
                .onChange(of: versionModel.fetchState) { _, _ in
                    tip.update()
                }
                
#if DEBUG
                Button("Debug Fetch State") {
                    versionModel.fetchState = switch versionModel.fetchState {
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
