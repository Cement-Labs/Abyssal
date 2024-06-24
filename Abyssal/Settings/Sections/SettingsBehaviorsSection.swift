//
//  SettingsBehaviorsSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import SwiftUI

struct SettingsBehaviorsSection: View {
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
            
            VStack {
                Picker(selection: .constant(1)) {
                    Text("Percentage").tag(1)
                    Text("Pixel").tag(2)
                } label: {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Dead zone")
                        
                        Spacer()
                        
                        if true {
                            Stepper(value: .constant(42), in: 0...Int.max) {
                                TextField(text: .constant("42")) {
                                    EmptyView()
                                }
                                .multilineTextAlignment(.trailing)
                                .lineLimit(1)
                                .monospaced()
                            }
                        }
                    }
                }
                
                EmptyFormWrapper {
                    Slider(value: .constant(0.25), in: 0...1) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    Form {
        SettingsBehaviorsSection()
    }
    .formStyle(.grouped)
}
