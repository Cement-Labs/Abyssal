//
//  NSSlider+Extension.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

extension NSSlider {
    
    var thumbRect: NSRect {
        return rectOfTickMark(at: integerValue)
    }
    
}
