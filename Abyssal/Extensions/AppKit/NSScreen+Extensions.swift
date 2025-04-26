//
//  NSScreen+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import AppKit

extension NSScreen {
    var displayID: CGDirectDisplayID? {
        deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? CGDirectDisplayID
    }
}
