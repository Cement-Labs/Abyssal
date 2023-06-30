//
//  NSSwitch+Extension.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import AppKit

extension NSSwitch {
    var flag: Bool {
        return self.state == .on
    }
}

extension NSSwitch {
    func set(_ flag: Bool) {
        self.state = flag ? .on : .off
    }
}
