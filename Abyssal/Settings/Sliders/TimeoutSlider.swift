//
//  TimeoutSlider.swift
//  Abyssal
//
//  Created by KrLite on 2024/11/8.
//

import SwiftUI
import Luminare
import Defaults

struct TimeoutSlider: View {
    @Default(.timeout) private var timeout

    var body: some View {
        LuminareSliderPickerCompose(
            "Timeout",
            Timeout.allCases,
            selection: $timeout
        ) { timeout in
            Group {
                let time = switch timeout {
                case .sec5, .sec10, .sec15, .sec30, .sec45:
                    TimeFormat.second.format(Double(timeout.rawValue))
                case .sec60, .min2, .min3, .min5, .min10:
                    TimeFormat.minute.format(Double(timeout.rawValue / 60))
                case .instant:
                    TimeFormat.instant
                case .forever:
                    TimeFormat.forever
                }

                Text(time)
            }
        }
    }
}

#Preview {
    LuminareSection {
        TimeoutSlider()
    }
    .padding()
}
