//
//  NSView+Extension.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit

extension NSView {
	
	var origin: CGPoint? {
		return self.window?.frame.origin
	}
	
}
