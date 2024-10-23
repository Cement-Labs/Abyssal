//
//  SettingsTrafficsView.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI
import Defaults

struct SettingsTrafficsView: View {
    @Default(.tipsEnabled) private var tipsEnabled
    
    @Environment(\.openURL) private var openUrl
    
    var body: some View {
        HStack {
            // Quit
            Box(isOn: false) {
                AbyssalApp.shared?.closeSettings(self)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    AbyssalApp.shared?.quit(self)
                }
            } content: {
                HStack {
                    Image(systemSymbol: .xmark)
                        .bold()
                    
                    Text("Quit \(Bundle.main.appName)")
                        .fixedSize()
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 12)
                .frame(maxHeight: .infinity)
            }
            .tint(.red)
            .foregroundStyle(.red)
            .keyboardShortcut("q", modifiers: .command)
            
            Spacer(minLength: 32)
            
            // Tips
            Box(isOn: $tipsEnabled, behavior: .toggle) {
                HStack {
                    Image(systemSymbol: tipsEnabled ? .tagFill : .tagSlashFill)
                        .bold()
                    
                    Text("Tips")
                        .fixedSize()
                }
                .contentTransition(.symbolEffect(.replace))
                .animation(.bouncy, value: tipsEnabled)
                
                .padding(.horizontal, 12)
                .frame(maxHeight: .infinity)
            }
            
            // Source
            TipWrapper(tip: sourceTip) { tip in
                Box(isOn: false) {
                    DispatchQueue.main.async {
                        AbyssalApp.shared?.closeSettings(self)
                    }
                    
                    DispatchQueue.main.async {
                        self.openUrl(.source)
                    }
                } content: {
                    Image(systemSymbol: .barcode)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 32)
            }
            
            // Minimize
            Box(isOn: false) {
                AbyssalApp.shared?.closeSettings(self)
            } content: {
                Image(systemSymbol: .arrowDownRightAndArrowUpLeft)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: 32)
            .tint(.orange)
            .foregroundStyle(.orange)
            .keyboardShortcut("w", modifiers: .command)
        }
        .frame(height: 32)
    }
    
    private let sourceTip = Tip(preferredEdge: .minY) {
        .init(localized: """
**\(Bundle.main.appName)** is open source. Click to access the source code.
""")
    }
}

#Preview {
    SettingsTrafficsView()
        .padding()
}
