//
//  TipDeadZoneTitle.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import SwiftUI
import Defaults

struct TipDeadZoneTitle: View {
    @Default(.deadZone) var deadZone
    
    var body: some View {
        let label = switch deadZone {
        case .percentage(let percentage):
            UnitFormat.percentage.format(percentage)
        case .pixel(let pixel):
            UnitFormat.pixel.format(pixel)
        }
        
        TipTitle(value: $deadZone) {
            Text(label)
        }
    }
}
