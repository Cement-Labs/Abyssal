//
//  StatusBarController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
	
	var mouseAbove: Bool {
		return Helper.Mouse.above(head.button?.origin)
	}
	
	var collapsed: Bool = false
	
	var timer: Timer?
	
	// MARK: - Constants
	
	static let COLLAPSE_DISABLED_LENGTH: 	CGFloat = 2
	
	static let COLLAPSE_IGNORED_LENGTH: 	CGFloat = 52
	
	static let NOTCH_DISABLED_AREA_WIDTH:	CGFloat = 290
	
	static let HEAD_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepDot"))
	
	static let SEPARATOR_ICON: 	NSImage? = NSImage(named:NSImage.Name("SepLine"))
	
	static let TAIL_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepDottedLine"))
	
	static let EMPTY_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepSpace"))
	
	// MARK: - Icons
	
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
	
	// MARK: - Methods
	
	private func repoint() {
		seps.sort {
			$0.button?.origin?.x ?? 0 < $1.button?.origin?.x ?? 0
		}
		
		saveSepsOrder()
	}
	
	private func remap() {
		if let button = self.head.button {
			button.image 	= (Helper.Keyboard.command && self.mouseAbove) || !collapsed ? StatusBarController.HEAD_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.separator.button {
			button.image 	= (Helper.Keyboard.command && self.mouseAbove) ? StatusBarController.SEPARATOR_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.tail.button {
			button.image 	= (Helper.Keyboard.command && self.mouseAbove) ? StatusBarController.TAIL_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
	}
	
	private func saveSepsOrder() {
		let sepsOrder: [Int?] = [seps.firstIndex(of: sep1), seps.firstIndex(of: sep2), seps.firstIndex(of: sep3)]
		Data.sepsOrder = sepsOrder
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
			withTimeInterval: 1.0 / 60.0,
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
		
		let maxLength = Helper.screenWidth ?? 10000
		var aimmedX: CGFloat
		
		if let screenWidth = Helper.screenWidth, Helper.hasNotch {
			aimmedX = screenWidth / 2.0 + StatusBarController.NOTCH_DISABLED_AREA_WIDTH / 2.0
		} else {
			aimmedX = 0
		}
		
		let popoverNotShown = !(Helper.delegate?.popover.isShown ?? false)
		
		// Head
		
		do {
			let flag = self.collapsed && !self.mouseAbove && popoverNotShown
			
			if Data.reduceAnimation {
				self.head.length = StatusBarController.COLLAPSE_DISABLED_LENGTH
			} else {
				self.head.length = Helper.lerp(
					a: self.head.length,
					b: flag ? StatusBarController.COLLAPSE_IGNORED_LENGTH : StatusBarController.COLLAPSE_DISABLED_LENGTH,
					ratio: Animations.LERP_RATIO
				)
			}
		}
		
		// Separator
		
		do {
			let flag = self.collapsed && !self.mouseAbove && popoverNotShown
			
			let length = self.separator.length
			guard let x = self.separator.button?.origin?.x else {
				return
			}
			
			if Data.reduceAnimation {
				self.separator.length = flag ? maxLength : StatusBarController.COLLAPSE_DISABLED_LENGTH
			} else {
				self.separator.length = Helper.lerp(
				 a: length,
				 b: flag ? max(0, x + length - aimmedX) : StatusBarController.COLLAPSE_DISABLED_LENGTH,
				 ratio: Animations.LERP_RATIO
			 )
			}
		}
		
		// Tail
		
		do {
			let flag = !(Helper.Keyboard.command && self.mouseAbove) && popoverNotShown
			
			if Data.reduceAnimation {
				self.tail.length = flag ? maxLength : StatusBarController.COLLAPSE_DISABLED_LENGTH
			} else {
				self.tail.length = Helper.lerp(
				 a: self.tail.length,
				 b: flag ? maxLength - aimmedX : StatusBarController.COLLAPSE_DISABLED_LENGTH,
				 ratio: Animations.LERP_RATIO
			 )
			}
		}
	}
	
	// MARK: - Show / hide icons
	
	func showHead() {
		self.tail.isVisible = true
	}
	
	func hideHead() {
		self.tail.isVisible = false
	}
	
	func showSeparator() {
		self.tail.isVisible = true
	}
	
	func hideSeparator() {
		self.tail.isVisible = false
	}
	
	func showTail() {
		self.tail.isVisible = true
	}
	
	func hideTail() {
		self.tail.isVisible = false
	}
	
}
