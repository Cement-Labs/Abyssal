//
//  BehaviorsSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import SwiftUI

struct BehaviorsSection: View {
    @Environment(\.hasTitle) private var hasTitle
    
    var body: some View {
        Section {
            SpacingVStack {
                Picker("Auto idling", selection: .constant(1)) {
                    Text("Test 1").tag(1)
                    Text("Test 2").tag(2)
                }
                
                Picker("Edge behavior", selection: .constant(1)) {
                    Text("Test 1").tag(1)
                    Text("Test 2").tag(2)
                }
            }
            
            SpacingVStack {
                DeadZoneControl()
            }
        } header: {
            if hasTitle {
                Text("Behaviors")
            }
        }
    }
}

#Preview {
    Form {
        BehaviorsSection()
    }
    .formStyle(.grouped)
}
