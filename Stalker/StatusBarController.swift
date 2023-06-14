//
//  StatusBarController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
	
	var collapsed: Bool = false
	
	var timer: Timer?
	
	// MARK: Constants
	
	static let COLLAPSE_DISABLED_LENGTH: 	CGFloat  = 2
	
	static let COLLAPSE_IGNORED_LENGTH: 	CGFloat  = 52
	
	static let COLLAPSE_ENABLED_LENGTH: 	CGFloat  = 10000
	
	static let LERP_RATIO: CGFloat = 0.079
	
	static let HEAD_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepWave"))
	
	static let SEPARATOR_ICON: 	NSImage? = NSImage(named:NSImage.Name("SepLine"))
	
	static let TAIL_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepDottedLine"))
	
	static let EMPTY_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepSpace"))
	
	// MARK: Icons
	
	// Actual separators
	
	let sep1: NSStatusItem = NSStatusBar.system.statusItem(
		withLength: NSStatusItem.variableLength
	)
	
	let sep2: NSStatusItem = NSStatusBar.system.statusItem(
		withLength: NSStatusItem.variableLength
	)
	
	let sep3: NSStatusItem = NSStatusBar.system.statusItem(
		withLength: NSStatusItem.variableLength
	)
	
	// Separators list
	
	var seps: [NSStatusItem]
	
	// Pointers specifying separators' positions
	
	var head: 		NSStatusItem {
		return seps[2]
	}
	
	var separator: 	NSStatusItem {
		return seps[1]
	}
	
	var tail: 		NSStatusItem {
		return seps[0]
	}
	
	init() {
		// sep[0] is the most left while sep[2] is the most right
		seps = [sep1, sep2, sep3]
		
		if let savedSepsOrder = Data.sepsOrder {
			if let sep1Order = savedSepsOrder[0], let sep2Order = savedSepsOrder[1], let sep3Order = savedSepsOrder[2] {
				seps[sep1Order] = sep1
				seps[sep2Order] = sep2
				seps[sep3Order] = sep3
			}
		}
	}
	
	// MARK: Methods
	
	private func repoint() {
		seps.sort {
			$0.button?.origin?.x ?? 0 < $1.button?.origin?.x ?? 0
		}
		
		saveSepsOrder()
	}
	
	private func remap() {
		if let button = self.head.button {
			button.image 	= Helper.Keyboard.command ? StatusBarController.HEAD_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.separator.button {
			button.image 	= Helper.Keyboard.command ? StatusBarController.SEPARATOR_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.tail.button {
			button.image 	= Helper.Keyboard.command ? StatusBarController.TAIL_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
	}
	
	private func saveSepsOrder() {
		let sepsOrder: [Int?] = [seps.firstIndex(of: sep1), seps.firstIndex(of: sep2), seps.firstIndex(of: sep3)]
		Data.sepsOrder(sepsOrder)
	}
	
	func setup() {
		repoint()
		remap()
		
		head.length 		= 0
		separator.length 	= 0
		tail.length 		= 0

		startTimer()
	}
	
	func enableCollapse() {
		self.collapsed = true
	}
	
	func disableCollapse() {
		self.collapsed = false
	}
	
	func startTimer() {
		timer = Timer.scheduledTimer(
			withTimeInterval: 0.01,
			repeats: true
		) { [weak self] _ in
			self?.repoint()
			self?.remap()
			
			self?.lerp()
		}
	}
	
	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	private func lerp() {
		var enabledLength = StatusBarController.COLLAPSE_ENABLED_LENGTH
		   
		if var screenWidth = Helper.screenWidth() {
			if Helper.hasNotch() {
				screenWidth /= 2.0
			}
			enabledLength = screenWidth
		}
		
		// Head
		
		do {
			let length = self.head.length
			self.head.length = Helper.lerp(
				a: length,
				b: self.collapsed ? StatusBarController.COLLAPSE_IGNORED_LENGTH : StatusBarController.COLLAPSE_DISABLED_LENGTH,
				ratio: StatusBarController.LERP_RATIO
			)
		}
		
		// Separator
		
		do {
			let length = self.separator.length
			
			self.separator.length = Helper.lerp(
				a: length,
				b: self.collapsed ? enabledLength : StatusBarController.COLLAPSE_DISABLED_LENGTH,
				ratio: StatusBarController.LERP_RATIO
			)
		}
		
		// Tail
		
		do {
			let length = self.tail.length
			
			self.tail.length = Helper.lerp(
				a: length,
				b: (!self.collapsed && Helper.Keyboard.command) ? StatusBarController.COLLAPSE_DISABLED_LENGTH : enabledLength,
				ratio: StatusBarController.LERP_RATIO
			)
		}
	}
	
}
