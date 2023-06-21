//
//  AnimationConstants.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation

class Animations {
	
	static var LERP_RATIO: CGFloat {
		let baseValue = 0.23
		return baseValue * (Helper.Keyboard.shift ? 0.25 : 1)
	}
	
}
