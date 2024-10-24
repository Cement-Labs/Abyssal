//
//  ApplicationMenuView.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/24.
//

import SwiftUI

struct ApplicationMenuView: View {
    var body: some View {
        Menu("\(Bundle.main.appName)") {
            Button("About \(Bundle.main.appName)") {
                abyssal.openSettings(with: .about)
            }
            
            Divider()
            
            Button("Close Settings") {
                abyssal.closeSettings()
            }
            .keyboardShortcut("w", modifiers: .command)
            
            Button("Quit \(Bundle.main.appName)") {
                abyssal.quit(self)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
    }
}
