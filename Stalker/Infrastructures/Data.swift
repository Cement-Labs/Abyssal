//
//  Data.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit

enum Data {
	
	class Keys {
		
		static let SEPS_ORDER: String = "sepsOrder"
		
		// MARK: - Booleans
		
		static let AUTO_HIDES_AFTER_TIMEOUT: String = "autoHides"
		
		static let USE_ALWAYS_HIDE_AREA: String = "alwaysHide"
		
		static let STARTS_WITH_MACOS: String = "startsWithSystem"
		
		// MARK: - Numbers
		
		static let MAX_ICON_WIDTH: String = "maxIconWidth"
		
		static let AUTO_HIDE_TIMEOUT: String = "timeout"
		
	}
	
	static var sepsOrder: [Int?]? {
		get {
			return UserDefaults.standard.array(
				forKey: Keys.SEPS_ORDER
			) as? [Int?]
		}
		
		set {
			UserDefaults.standard.set(
				newValue,
				forKey: Keys.SEPS_ORDER
			)
		}
	}
	
	static var autoHidesAfterTimeout: Bool {
		get {
			return UserDefaults.standard.bool(
				forKey: Keys.AUTO_HIDES_AFTER_TIMEOUT
			)
		}
		
		set {
			UserDefaults.standard.set(
				newValue,
				forKey: Keys.AUTO_HIDES_AFTER_TIMEOUT
			)
		}
	}
	
	static var useAlwaysHideArea: Bool {
		get {
			return UserDefaults.standard.bool(
				forKey: Keys.USE_ALWAYS_HIDE_AREA
			)
		}
		
		set {
			UserDefaults.standard.set(
				newValue,
				forKey: Keys.USE_ALWAYS_HIDE_AREA
			)
		}
	}
	
	static var startsWithMacos: Bool {
		get {
			return UserDefaults.standard.bool(
				forKey: Keys.STARTS_WITH_MACOS
			)
		}
		
		set {
			UserDefaults.standard.set(
				newValue,
				forKey: Keys.STARTS_WITH_MACOS
			)
		}
	}
	
}
