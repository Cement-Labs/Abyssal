//
//  NSRect+Extension.swift
//  Stalker
//
//  Created by KrLite on 2023/6/17.
//

import Foundation

extension NSRect {
    
    var containsMouse: Bool {
        return Helper.Mouse.inside(self)
    }
    
}
