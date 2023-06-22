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
	
	static let SOURCE_CODE_URL: URL 	= URL(string: "https://github.com/KrLite/Stalker")!
	
	static let RELEASE_URL: URL 		= URL(string: "https://github.com/KrLite/Stalker/releases")!
	
	static let RELEASE_TAGS_URL: URL 	= URL(string: "https://api.github.com/repos/KrLite/Stalker/tags")!
	
	static let CHECK_NEWER_VERSION_TASK = URLSession.shared.dataTask(with: RELEASE_TAGS_URL) { (data, response, error) in
		guard let data = data else { return }
		
		do {
			if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
				let tags = json.sorted { (v1, v2) -> Bool in
					let name1 = v1["name"] as? String ?? ""
					let name2 = v2["name"] as? String ?? ""
					return name2.compare(name1, options: .numeric) == .orderedAscending
				}
				if let latestTag = tags.first?["name"] as? String {
					Helper.latestTag = latestTag
				}
			}
		} catch {
			print(error.localizedDescription)
		}
	}
	
	static var version: String? {
		return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	}
	
	static var _latestTag: String = ""
	
	static var latestTag: String {
		get {
			return _latestTag
		}
		
		set(version) {
			let pattern = "^v?(\\d+\\.\\d+)"
			if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
				let nsVersion = version as NSString
				if let match = regex.firstMatch(
					in: 		version,
					options: 	[],
					range: 		NSRange(location: 0, length: nsVersion.length)
				) {
					if let versionRange = Range(match.range(at: 1), in: version) {
						let versionNumber = String(version[versionRange])
						Helper._latestTag = versionNumber
					}
				}
			} else {
				_latestTag = ""
			}
		}
	}
	
	static var versionComponent: (needsUpdate: Bool, color: NSColor, version: String) {
		if let version = version {
			switch compareVersions(version, latestTag) {
			case .orderedAscending: // Needs an update
				return (true, .systemGreen, latestTag)
			default:
				return (false, .systemPink, version)
			}
		} else {
			print("Version information not found")
			return (false, .systemPink, "...")
		}
	}
	
	static var delegate: AppDelegate? {
		return NSApplication.shared.delegate as? AppDelegate
	}
	
	static func lerp(
		a: 			CGFloat,
		b: 			CGFloat,
		ratio: 		CGFloat,
		_ ignoreSmallValues: Bool = true
	) -> CGFloat {
		guard !ignoreSmallValues || abs(b - a) >= 1 else { return b }
		return a + (b - a) * ratio
	}
	
    static func lerpAsync(
        a: 			CGFloat,
        b: 			CGFloat,
        ratio: 		CGFloat,
		_ ignoreSmallValues: Bool = true,
		completion: @escaping (Double) -> Void
    ) {
		guard !ignoreSmallValues || abs(b - a) >= 1 else { return }
		DispatchQueue.global().async {
			completion(a + (b - a) * ratio)
		}
    }
	
	static func compareVersions(
		_ version1: String?,
		_ version2: String?
	) -> ComparisonResult {
		if version1 == nil && version2 != nil { return .orderedAscending }
		else if version2 == nil && version1 != nil { return .orderedDescending }
		
		guard
			let version1 = version1,
			let version2 = version2
		else {
			return .orderedSame
		}
		
		if version1 == "" && version2 != "" { return .orderedAscending }
		else if version2 == "" && version1 != "" { return .orderedDescending }
		
		guard version1 != version2 else {
			return .orderedSame
		}
		
		let components1 = version1.components(separatedBy: ".")
		let components2 = version2.components(separatedBy: ".")
		let count = max(components1.count, components2.count)
		
		for i in 0..<count {
			let value1 = i < components1.count ? Int(components1[i]) ?? 0 : 0
			let value2 = i < components2.count ? Int(components2[i]) ?? 0 : 0
			if value1 < value2 {
				return .orderedAscending
			} else if value1 > value2 {
				return .orderedDescending
			}
		}
		
		return .orderedSame
	}
	
	class Screen {
		
		static var frame: NSRect? {
			return NSScreen.main?.frame
		}
		
		static var hasNotch: Bool {
			guard #available(macOS 12, *) else { return false }
			return NSScreen.main?.safeAreaInsets.top != 0
		}
		
		static var width: 		CGFloat? {
			return NSScreen.main?.frame.size.width ?? nil
		}
		
		static var height: 		CGFloat? {
			return NSScreen.main?.frame.size.height ?? nil
		}
		
		static var maxWidth: 	CGFloat? {
			let screens = NSScreen.screens
			var maxWidth: CGFloat?

			for screen in screens {
				let screenFrame = screen.visibleFrame
				if maxWidth == nil || screenFrame.size.width > maxWidth ?? 0 {
					maxWidth = screenFrame.size.width
				}
			}
			
			return maxWidth
		}
		
		static var maxHeight: 	CGFloat? {
			let screens = NSScreen.screens
			var maxHeight: CGFloat?

			for screen in screens {
				let screenFrame = screen.visibleFrame
				if maxHeight == nil || screenFrame.size.height > maxHeight ?? 0 {
					maxHeight = screenFrame.size.height
				}
			}
			
			return maxHeight
		}
		
	}
	
	class Keyboard {
		
		static var command: Bool {
			return NSEvent.modifierFlags.contains(.command)
		}
		
		static var option: Bool {
			return NSEvent.modifierFlags.contains(.option)
		}
		
		static var shift: Bool {
			return NSEvent.modifierFlags.contains(.shift)
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
