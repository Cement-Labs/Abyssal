//
//  BehaviorsSection.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import SwiftUI
import Defaults

struct BehaviorsSection: View {
    @Default(.screenSettings) private var screenSettings
    
    @Environment(\.hasTitle) private var hasTitle
    
    @State var isScreenInformationPresented: Bool = false
    
    var body: some View {
        Section {
            SpacingVStack {
                CollapseStrategyControl()
                
                RespectNotchControl()
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
                    Box(isOn: $screenSettings.isMainUnique, behavior: .toggle) {
                        Text("Remember This Screen")
                            .padding(.horizontal, 10)
                            .frame(height: 24)
                    }
                    
                    Box(isOn: $isScreenInformationPresented, behavior: .toggle) {
                        Image(systemSymbol: .info)
                            .frame(width: 24, height: 24)
                    }
                    .popover(isPresented: $isScreenInformationPresented) {
                        EmptyFormWrapper(normalizePadding: false) {
                            Section("Screen Information") {
                                if let id = ScreenManager.main?.displayID {
                                    LabeledContent("Display ID") {
                                        Text(String(id))
                                            .monospaced()
                                    }
                                    
                                    LabeledContent("Width") {
                                        Text(UnitFormat.pixel.format(Double(ScreenManager.frame.width)))
                                            .monospaced()
                                    }
                                    
                                    LabeledContent("Height") {
                                        Text(UnitFormat.pixel.format(Double(ScreenManager.frame.height)))
                                            .monospaced()
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
