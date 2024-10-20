//
//  StartsWithMacOSControl.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import LaunchAtLogin

struct StartsWithMacOSControl: View {
    var body: some View {
        TipWrapper(tip: tip) { tip in
            LaunchAtLogin.Toggle {
                Text("Starts with macOS")
            }
        }
    }
    
    private let tip = Tip {
        .init(localized: """
Launch **\(Bundle.main.appName)** right after macOS starts.
""")
    }
}

#Preview {
    Form {
        StartsWithMacOSControl()
    }
    .formStyle(.grouped)
}
