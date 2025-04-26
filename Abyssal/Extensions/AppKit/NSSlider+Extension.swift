//
//  NSSlider+Extension.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import AppKit
import Foundation

extension NSSlider {
    @objc dynamic var knobRect: NSRect {
        (cell as? NSSliderCell)?.knobRect(flipped: false) ?? visibleRect
    }
}
