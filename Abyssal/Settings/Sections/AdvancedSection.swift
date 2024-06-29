//
//  AdvancedSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI

struct AdvancedSection: View {
    @Environment(\.hasTitle) private var hasTitle
    
    var body: some View {
        Section {
            SpacingVStack {
                TimeoutControl()
            }
            
            SpacingVStack {
                StartsWithMacOSControl()
            }
        } header: {
            if hasTitle {
                Text("Advanced")
            }
        }
    }
}

#Preview {
    Form {
        AdvancedSection()
    }
    .formStyle(.grouped)
}
