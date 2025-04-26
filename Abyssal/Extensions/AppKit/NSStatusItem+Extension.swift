//
//  NSStatusItem+Extension.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/19.
//

import AppKit

extension NSStatusItem {
    var origin: CGPoint? {
        button?.window?.frame.origin
    }
}
