//
//  NSStatusBarButton+Extension.swift
//  Stalker
//
//  Created by KrLite on 2023/6/19.
//

import AppKit

extension NSStatusItem {
	
	var origin: CGPoint? {
		return self.button?.window?.frame.origin
	}
	
}
