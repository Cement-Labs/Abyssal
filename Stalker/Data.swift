//
//  Data.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit

class Data {
	
	class Keys {
		
		static let SEPS_ORDER: String = "sepsOrder"
		
		// MARK: Booleans
		
		static let AUTO_HIDES_AFTER_TIMEOUT: String = "autoHides"
		
		static let USE_ALWAYS_HIDE_AREA: String = "alwaysHide"
		
		static let STARTS_WITH_MACOS: String = "startsWithSystem"
		
		// MARK: Numbers
		
		static let MAX_ICON_WIDTH: String = "maxIconWidth"
		
		static let AUTO_HIDE_TIMEOUT: String = "timeout"
		
	}
	
	static var sepsOrder: [Int?]? {
		return UserDefaults.standard.array(forKey: Keys.SEPS_ORDER) as? [Int?]
	}
	
	static func sepsOrder(_ newSepsOrder: [Int?]?) {
		UserDefaults.standard.set(newSepsOrder, forKey: Keys.SEPS_ORDER)
	}
	
}
