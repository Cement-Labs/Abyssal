//
//  Data.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import Foundation
import AppKit
import LaunchAtLogin

enum Data {
	
	class Keys {
		
		static let SEPS_ORDER: String = "sepsOrder"
		
		// MARK: - Booleans
		
		static let AUTO_HIDES_AFTER_TIMEOUT: 	String = "autoHides"
		
		static let USE_ALWAYS_HIDE_AREA: 		String = "alwaysHide"
		
		static let REDUCE_ANIMATION: 			String = "reduceAnimation"
		
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
	
	static var autoHides: Bool {
		get { return UserDefaults.standard.bool(forKey: Keys.AUTO_HIDES_AFTER_TIMEOUT) }
		
		set { UserDefaults.standard.set(newValue, forKey: Keys.AUTO_HIDES_AFTER_TIMEOUT) }
	}
	
	static var useAlwaysHideArea: Bool {
		get { return UserDefaults.standard.bool(forKey: Keys.USE_ALWAYS_HIDE_AREA) }
		
		set { UserDefaults.standard.set(newValue, forKey: Keys.USE_ALWAYS_HIDE_AREA) }
	}
	
	static var startsWithMacos: Bool {
		get { return LaunchAtLogin.isEnabled }
		
		set { LaunchAtLogin.isEnabled = newValue }
	}
	
	static var reduceAnimation: Bool {
		get { return UserDefaults.standard.bool(forKey: Keys.REDUCE_ANIMATION) }
		
		set { UserDefaults.standard.set(newValue, forKey: Keys.REDUCE_ANIMATION) }
	}
	
}
