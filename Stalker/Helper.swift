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
	
    static func lerp(
        a: CGFloat,
        b: CGFloat,
        ratio: CGFloat
    ) -> CGFloat {
        return a + (b - a) * ratio
    }
    
    static func screenWidth() -> CGFloat? {
        return NSScreen.main?.frame.size.width ?? nil
    }
    
    static func hasNotch() -> Bool {
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
	
}
