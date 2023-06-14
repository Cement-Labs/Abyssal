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
	
	static let collapseDisabledLength: CGFloat  = 2
	
	static let collapseIgnoredLength: CGFloat   = 32
	
	static let collapseEnabledLength: CGFloat   = 10000
	
	static let lerpRatio: CGFloat = 0.079
	
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
	}
	
	// MARK: Methods
	
	private func repoint() {
		let x1 = sep1.button?.origin?.x ?? 0
		let x2 = sep2.button?.origin?.x ?? 0
		let x3 = sep3.button?.origin?.x ?? 0
		
		guard x1 != x2 || x2 != x3 else {
			// x1 == x2 == x3, no need to repoint
			return;
		}
		
		seps.sort {
			$0.button?.origin?.x ?? 0 < $1.button?.origin?.x ?? 0
		}
	}
	
	private func remap() {
		if let button = self.head.button {
			button.image 	= NSImage(named:NSImage.Name("SepWave"))
			button.action 	= #selector(AppDelegate.togglePopover(_:))
		}
		
		if let button = self.separator.button {
			button.image 	= NSImage(named:NSImage.Name("SepLine"))
			button.action 	= #selector(AppDelegate.togglePopover(_:))
		}
		
		if let button = self.tail.button {
			button.image 	= NSImage(named:NSImage.Name("SepDottedLine"))
			button.action 	= #selector(AppDelegate.togglePopover(_:))
		}
	}
	
	func setup() {
		remap()
		
		head.length 		= 0
		separator.length 	= 0
		tail.length 		= 0
		
		repoint()
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
		do {
			let length = self.head.length
			self.head.length = Helper.lerp(
				a: length,
				b: self.collapsed ? StatusBarController.collapseIgnoredLength : StatusBarController.collapseDisabledLength,
				ratio: StatusBarController.lerpRatio
			)
		}
		
		do {
			let length = self.separator.length
			var enabledLength = StatusBarController.collapseEnabledLength
			
			if var screenWidth = Helper.screenWidth() {
				if Helper.hasNotch() {
					screenWidth /= 2.0
				}
				enabledLength = screenWidth
			}
			
			self.separator.length = Helper.lerp(
				a: length,
				b: self.collapsed ? enabledLength : StatusBarController.collapseDisabledLength,
				ratio: StatusBarController.lerpRatio
			)
		}
		
		do {
			let length = self.tail.length
			self.tail.length = Helper.lerp(
				a: length,
				b: self.collapsed ? StatusBarController.collapseIgnoredLength : StatusBarController.collapseDisabledLength,
				ratio: StatusBarController.lerpRatio
			)
		}
	}
	
}
