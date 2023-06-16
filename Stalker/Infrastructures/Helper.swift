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
    
	static var hasNotch: Bool {
        guard #available(macOS 12, *) else { return false }
        return NSScreen.main?.safeAreaInsets.top != 0
    }
	
	class Screen {
		
		static var width: CGFloat? {
			return NSScreen.main?.frame.size.width ?? nil
		}
		
		static var height: CGFloat? {
			return NSScreen.main?.frame.size.height ?? nil
		}
		
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
		
		static func above(
			_ y: CGFloat
		) -> Bool {
			return Mouse.above(CGPoint(x: 0, y: y))
		}
		
		static func under(
			_ point: CGPoint?
		) -> Bool {
			let mouseLocationY = NSEvent.mouseLocation.y
			if let borderY = point?.y {
				return mouseLocationY <= borderY
			} else {
				return false
			}
		}
		
		static func under(
			_ y: CGFloat
		) -> Bool {
			return Mouse.under(CGPoint(x: 0, y: y))
		}
		
		static func left(
			_ point: CGPoint?
		) -> Bool {
			let mouseLocationX = NSEvent.mouseLocation.x
			if let borderX = point?.x {
				return mouseLocationX <= borderX
			} else {
				return false
			}
		}
		
		static func left(
			_ x: CGFloat
		) -> Bool {
			return Mouse.left(CGPoint(x: x, y: 0))
		}
		
		static func right(
			_ point: CGPoint?
		) -> Bool {
			let mouseLocationX = NSEvent.mouseLocation.x
			if let borderX = point?.x {
				return mouseLocationX >= borderX
			} else {
				return false
			}
		}
		
		static func right(
			_ x: CGFloat
		) -> Bool {
			return Mouse.right(CGPoint(x: x, y: 0))
		}
		
		static func inside(
			_ rect: NSRect?
		) -> Bool {
			return rect?.contains(NSEvent.mouseLocation) ?? false
		}
		
	}
	
}
