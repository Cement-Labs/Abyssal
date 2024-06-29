//
//  GeneralSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/22.
//

import SwiftUI

struct GeneralSection: View {
    @Environment(\.hasTitle) private var hasTitle
    
    var body: some View {
        Section {
            SpacingVStack {
                ThemeControl()
            }
            
            SpacingVStack {
                FeedbackControl()
            }
        } header: {
            if hasTitle {
                Text("General")
            }
        }
    }
}

#Preview {
    Form {
        GeneralSection()
    }
    .formStyle(.grouped)
}
