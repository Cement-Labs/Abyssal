//
//  FunctionsView.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/20.
//

import SwiftUI
import Luminare
import Defaults

struct FunctionsView: View {
    @Default(.autoShowsEnabled) private var autoShowsEnabled
    @Default(.alwaysHiddenAreaEnabled) private var alwaysHiddenAreaEnabled
    
    var body: some View {
        LuminareSection {
            LuminareCompose("Auto shows", reducesTrailingSpace: true) {
                Toggle("", isOn: $autoShowsEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }
            
            LuminareCompose("Always hidden area", reducesTrailingSpace: true) {
                Toggle("", isOn: $alwaysHiddenAreaEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }
        }
    }
}

#Preview {
    FunctionsView()
        .padding()
}
