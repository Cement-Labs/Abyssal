//
//  Separator.swift
//  Stalker
//
//  Created by KrLite on 2023/6/16.
//

import Foundation
import AppKit

class Separator: NSStatusItem, NSAnimatablePropertyContainer {
	
	dynamic override var length: CGFloat {
		get {
			return super.length
		}
		
		set {
			super.length = newValue
		}
	}
	
	var animations: [NSAnimatablePropertyKey : Any]
	
	override init() {
		animations = [:]
		
		super.init()
		
		animations["length"] = length
	}
	
	func animator() -> Self {
		return self
	}
	
	func animation(forKey key: NSAnimatablePropertyKey) -> Any? {
		return Separator.defaultAnimation(forKey: key)
	}
	
	static func defaultAnimation(forKey key: NSAnimatablePropertyKey) -> Any? {
		switch key {
		case "length":
			return CABasicAnimation(keyPath: key)
		default:
			return nil
		}
	}
	
}
