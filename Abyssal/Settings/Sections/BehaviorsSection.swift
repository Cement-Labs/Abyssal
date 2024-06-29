//
//  BehaviorsSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import SwiftUI
import Defaults

struct BehaviorsSection: View {
    @Default(.screenUniqueSettings) var screenUniqueSettings
    
    @Environment(\.hasTitle) private var hasTitle
    
    @State var isScreenInformationPresented: Bool = false
    @State var test = false
    
    var body: some View {
        Section {
            SpacingVStack {
                CollapseStrategyControl()
            }
            
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
            HStack {
                if hasTitle {
                    Text("Behaviors")
                }
                
                Spacer()
                
                Group {
                    Box(isOn: $test, behavior: .toggle) {
                        Text("Remember This Screen")
                            .padding(.horizontal, 10)
                            .frame(height: 24)
                    }
                    .onChange(of: test) { _, _ in
                        print(ScreenManager.id, ScreenManager.main?.deviceDescription)
                    }
                    
                    Box(isOn: $isScreenInformationPresented, behavior: .toggle) {
                        Image(systemSymbol: .info)
                            .frame(width: 24, height: 24)
                    }
                    .popover(isPresented: $isScreenInformationPresented) {
                        EmptyFormWrapper(normalizePadding: false) {
                            Section("Screen Information") {
                                LabeledContent("Hash") {
                                    Button {
                                        
                                    } label: {
                                        Text(String(format: "%X", ScreenManager.hash))
                                    }
                                }
                                
                                if let id = ScreenManager.id {
                                    LabeledContent("ID") {
                                        Button {
                                            
                                        } label: {
                                            Text(String(describing: id))
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .font(.subheadline)
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
