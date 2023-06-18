//
//  Data.swift
//  Stalker
//
//  Created by KrLite on 2023/6/14.
//

import AppKit
import LaunchAtLogin

public enum Data {
	
	public class Keys {
		
		public static let SEPS_ORDER: String = "sepsOrder"
		
		// MARK: - Booleans
		
		public static let COLLAPSED:					String = "collapsed"
		
		
		
		public static let AUTO_HIDES_AFTER_TIMEOUT: 	String = "autoHides"
		
		public static let USE_ALWAYS_HIDE_AREA: 		String = "alwaysHide"
		
		public static let DISABLES_IN_SUFFICIENT_SPACE: String = "autoDisables"
		
		public static let REDUCE_ANIMATION: 			String = "reduceAnimation"
		
	}
	
	public static var sepsOrder: [Int?]? {
		get {
			return UserDefaults.standard.array(
				forKey: Keys.SEPS_ORDER
			) as? [Int?]
		}
		
		set(sepsOrder) {
			UserDefaults.standard.set(
				sepsOrder,
				forKey: Keys.SEPS_ORDER
			)
		}
	}
	
	
	
	public static var collapsed: Bool {
		get {
			return UserDefaults.standard.bool(forKey: Keys.COLLAPSED)
		}
		
		set(flag) {
			UserDefaults.standard.set(flag, forKey: Keys.COLLAPSED)
		}
	}
	
	
	
	public static var autoHides: 					Bool {
		get {
			return UserDefaults.standard.bool(forKey: Keys.AUTO_HIDES_AFTER_TIMEOUT)
		}
		
		set(flag) {
			UserDefaults.standard.set(flag, forKey: Keys.AUTO_HIDES_AFTER_TIMEOUT)
		}
	}
	
	public static var useAlwaysHideArea: 			Bool {
		get {
			return UserDefaults.standard.bool(forKey: Keys.USE_ALWAYS_HIDE_AREA)
		}
		
		set(flag) {
			UserDefaults.standard.set(flag, forKey: Keys.USE_ALWAYS_HIDE_AREA)
		}
	}
	
	public static var startsWithMacos: 				Bool {
		get {
			return LaunchAtLogin.isEnabled
		}
		
		set(flag) {
			LaunchAtLogin.isEnabled = flag
		}
	}
	
	public static var disablesInSufficientSpace: 	Bool {
		get {
			return UserDefaults.standard.bool(forKey: Keys.DISABLES_IN_SUFFICIENT_SPACE)
		}
		
		set(flag) {
			UserDefaults.standard.set(flag, forKey: Keys.DISABLES_IN_SUFFICIENT_SPACE)
		}
	}
	
	public static var reduceAnimation: 				Bool {
		get {
			return UserDefaults.standard.bool(forKey: Keys.REDUCE_ANIMATION)
		}
		
		set(flag) {
			UserDefaults.standard.set(flag, forKey: Keys.REDUCE_ANIMATION)
		}
	}
	
}
