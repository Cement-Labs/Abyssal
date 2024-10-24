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
            // quit
            Box(isOn: false) {
                abyssal.closeSettings()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    abyssal.quit(self)
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
            
            // tips
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
            
            // source
            TipWrapper(tip: sourceTip) { tip in
                Box(isOn: false) {
                    DispatchQueue.main.async {
                        abyssal.closeSettings()
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
            
            // minimize
            Box(isOn: false) {
                abyssal.closeSettings()
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
