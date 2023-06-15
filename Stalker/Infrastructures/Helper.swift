//
//  Helper.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import ApplicationServices
import AppKit

class Helper {
	
	static let SOURCE_CODE_URL: URL? = URL(string: "https://github.com/KrLite/Stalker")
	
	static let SPONSOR_URL: 	URL? = nil
	
    static func lerp(
        a: CGFloat,
        b: CGFloat,
        ratio: CGFloat
    ) -> CGFloat {
        return a + (b - a) * ratio
    }
	
	static var delegate: AppDelegate? {
		return NSApplication.shared.delegate as? AppDelegate
	}
    
	static var screenWidth: CGFloat? {
        return NSScreen.main?.frame.size.width ?? nil
    }
    
	static var hasNotch: Bool {
        guard #available(macOS 12, *) else { return false }
        return NSScreen.main?.safeAreaInsets.top != 0
    }
	
	class Keyboard {
		
		static var command: Bool {
			return NSEvent.modifierFlags.contains(.command)
		}
		
		static var option: Bool {
			return NSEvent.modifierFlags.contains(.option)
		}
		
	}
	
	class Mouse {
		
		static func above(
			_ point: CGPoint?
		) -> Bool {
			let mouseLocationY = NSEvent.mouseLocation.y
			if let borderY = point?.y {
				return mouseLocationY >= borderY
			} else {
				return false
			}
		}
		
	}
	
}
