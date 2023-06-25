//
//  AnimationConstants.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit

extension StatusBarController {
	
	static var lerpRatio: CGFloat {
		let baseValue = 0.23
		return baseValue * (Helper.Keyboard.shift ? 0.25 : 1)
	}
	
}
