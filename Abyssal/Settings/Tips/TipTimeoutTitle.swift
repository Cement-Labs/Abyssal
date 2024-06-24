//
//  TipTimeoutTitle.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import SwiftUI
import Defaults

struct TipTimeoutTitle: View {
    @Default(.timeout) private var timeout
    
    var body: some View {
        let label = switch timeout {
        case .sec5, .sec10, .sec15, .sec30, .sec45:
            TimeFormat.inSeconds(Double(timeout.rawValue))
        case .sec60, .min2, .min3, .min5, .min10:
            TimeFormat.inMinutes(Double(timeout.rawValue / 60))
        default: 
            TimeFormat.forever
        }
        
        TipTitle(value: $timeout) {
            Text(label)
        }
    }
}
