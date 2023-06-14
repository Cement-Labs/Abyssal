//
//  NSButton+Extension.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit

extension NSButton {
	var flag: Bool {
		return self.state == .on
	}
}

extension NSButton {
	func set(_ flag: Bool) {
		self.state = flag ? .on : .off
	}
}
