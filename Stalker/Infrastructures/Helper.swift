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
	
    static func lerpAsync(
        a: 			CGFloat,
        b: 			CGFloat,
        ratio: 		CGFloat,
		completion: @escaping (Double) -> Void
    ) {
		guard abs(b - a) >= 1 else { return }
		DispatchQueue.global().async {
			completion(a + (b - a) * ratio)
		}
    }
	
	static var delegate: AppDelegate? {
		return NSApplication.shared.delegate as? AppDelegate
	}
	
	class Screen {
		
		static var frame: NSRect? {
			return NSScreen.main?.frame
		}
		
		static var hasNotch: Bool {
			guard #available(macOS 12, *) else { return false }
			return NSScreen.main?.safeAreaInsets.top != 0
		}
		
		static var width: 	CGFloat? {
			return NSScreen.main?.frame.size.width ?? nil
		}
		
		static var height: 	CGFloat? {
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
		
		static func inside(
			_ rect: NSRect?
		) -> Bool {
			return rect?.contains(NSEvent.mouseLocation) ?? false
		}
		
	}
	
}
