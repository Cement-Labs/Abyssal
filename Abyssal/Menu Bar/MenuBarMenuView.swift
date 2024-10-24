//
//  MenuBarMenuView.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/23.
//

import SwiftUI

struct MenuBarMenuView: View {
    var body: some View {
        Button("Settings…") {
            abyssal.openSettings()
        }
        
        Button("Quit \(Bundle.main.appName)") {
            abyssal.quit(self)
        }
    }
}
