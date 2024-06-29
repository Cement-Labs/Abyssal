//
//  TipDeadZoneTitle.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct TipDeadZoneTitle: View {
    @Default(.screenSettings) var screenSettings
    
    var body: some View {
        let label = switch screenSettings.main.deadZone {
        case .percentage(let percentage):
            UnitFormat.percentage.format(percentage)
        case .pixel(let pixel):
            UnitFormat.pixel.format(pixel)
        }
        
        TipTitle(value: $screenSettings.main.deadZone) {
            Text(label)
        }
    }
}
