//
//  StatusBarController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
	
	var mouseOver: 		Bool {
		return Helper.Mouse.above(head.button?.origin) && (!Helper.hasNotch || Helper.Mouse.right((Helper.Screen.width ?? 0) / 2))
	}
	
	var mouseIdle: 		Bool {
		if
			let originTail = tail.button?.origin,
			let originHead = head.button?.origin,
			let screenHeight = Helper.Screen.height
		{
			let rect = NSRect(
				x: 		originTail.x + tail.length,
				y: 		originTail.y,
				width: 	originHead.x - (originTail.x + tail.length),
				height: screenHeight - originHead.y
			)
			
			return Helper.Mouse.inside(rect)
		} else {
			return false
		}
	}
	
	var mouseTrigger: 	Bool {
		if
			let origin = head.button?.origin,
			let screenHeight = Helper.Screen.height
		{
			let rect = NSRect(
				x: 		origin.x,
				y: 		origin.y,
				width: 	head.length + 20,
				height: screenHeight - origin.y
			)
			
			return Helper.Mouse.inside(rect)
		} else {
			return false
		}
	}
	
	var collapsed: 	Bool = false
	
	var idling: 	Bool = false
	
	var timer: Timer?
	
	var mouseClickEventMonitor: EventMonitor?
	
	var mouseMovedEventMonitor: EventMonitor?
	
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
	
	private let _sep1: NSStatusItem = NSStatusBar.system.statusItem(
		withLength: NSStatusItem.variableLength
	)
	
	private let _sep2: NSStatusItem = NSStatusBar.system.statusItem(
		withLength: NSStatusItem.variableLength
	)
	
	private let _sep3: NSStatusItem = NSStatusBar.system.statusItem(
		withLength: NSStatusItem.variableLength
	)
	
	// Separators list
	
	private var _seps: [NSStatusItem]
	
	// Pointers specifying separators' positions
	
	var head: 		NSStatusItem {
		var order: Int = 2
		
		if let savedSepsOrder = Data.sepsOrder, let savedOrder = savedSepsOrder[order] {
			order = savedOrder
		}
		
		return _seps[order]
	}
	
	var separator: 	NSStatusItem {
		var order: Int = 1
		
		if let savedSepsOrder = Data.sepsOrder, let savedOrder = savedSepsOrder[order] {
			order = savedOrder
		}
		
		return _seps[order]
	}
	
	var tail: 		NSStatusItem {
		var order: Int = 0
		
		if let savedSepsOrder = Data.sepsOrder, let savedOrder = savedSepsOrder[order] {
			order = savedOrder
		}
		
		return _seps[order]
	}
	
	init() {
		// _sep1 is the most left while _sep2 is the most right
		_seps = [_sep1, _sep2, _sep3]
	}
	
	// MARK: - Methods
	
	private func repoint() {
		guard _seps.allSatisfy ({ sep in
			sep.button?.origin?.x ?? 0 > 0
		}) else {
			return
		}
		
		saveSepsOrder(
			_seps.sorted {
				$0.button?.origin?.x ?? 0 < $1.button?.origin?.x ?? 0
			}
		)
	}
	
	private func remap() {
		if let button = self.head.button {
			button.image 	= (Helper.Keyboard.command && self.mouseOver) || !collapsed ? StatusBarController.HEAD_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.separator.button {
			button.image 	= (Helper.Keyboard.command && self.mouseOver) ? StatusBarController.SEPARATOR_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.tail.button {
			button.image 	= (Helper.Keyboard.command && self.mouseOver) ? StatusBarController.TAIL_ICON : StatusBarController.EMPTY_ICON
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
	}
	
	private func saveSepsOrder(
		_ currentSeps: [NSStatusItem]
	) {
		let sepsOrder: [Int?] = [_seps.firstIndex(of: currentSeps[0]),
								 _seps.firstIndex(of: currentSeps[1]),
								 _seps.firstIndex(of: currentSeps[2])]
		Data.sepsOrder = sepsOrder
	}
	
	func setup() {
		// Init status icons
		
		head.length 		= 0
		separator.length 	= 0
		tail.length 		= 0
		
		startTimers()
		startMonitors()
	}
	
	func terminate() {
		stopTimers()
		stopMonitors()
	}
	
	func enableCollapse() {
		self.collapsed = true
	}
	
	func disableCollapse() {
		self.collapsed = false
	}
	
	func enableIdle() {
		self.idling = true
	}
	
	func disableIdle() {
		self.idling = false
	}
	
	func startTimers() {
		timer = Timer.scheduledTimer(
			withTimeInterval: 1.0 / 60.0,
			repeats: true
		) { [weak self] _ in
			if let strongSelf = self {
				strongSelf.remap()
				strongSelf.lerp()
				strongSelf.repoint()
			}
		}
	}
	
	func stopTimers() {
		timer?.invalidate()
		timer = nil
	}
	
	func startMonitors() {
		mouseClickEventMonitor = EventMonitor(
			mask: [.leftMouseDown,
				   .rightMouseDown]
		) { [weak self] event in
			if let strongSelf = self {
				if strongSelf.mouseIdle && strongSelf.collapsed {
					strongSelf.enableIdle()
				}
			}
		}
		
		mouseMovedEventMonitor = EventMonitor(
			mask: [.mouseMoved]
		) { [weak self] event in
			if let strongSelf = self {
				if strongSelf.mouseTrigger && strongSelf.idling {
					strongSelf.disableIdle()
				}
			}
		}
		
		mouseClickEventMonitor?.start()
		mouseMovedEventMonitor?.start()
	}
	
	func stopMonitors() {
		mouseClickEventMonitor?.stop()
		mouseMovedEventMonitor?.stop()
	}
	
	func hold() {
		disableCollapse()
	}
	
	private func lerp() {
		let maxLength = Helper.Screen.width ?? 10000
		var aimmedX: CGFloat
		
		if let screenWidth = Helper.Screen.width, Helper.hasNotch {
			aimmedX = screenWidth / 2.0 + StatusBarController.NOTCH_DISABLED_AREA_WIDTH / 2.0
		} else {
			aimmedX = 0
		}
		
		let popoverNotShown = !(Helper.delegate?.popover.isShown ?? false)
		
		// Head
		
		do {
			let flag = self.collapsed && !self.idling && !self.mouseOver && popoverNotShown
			
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
			// Use always hide?
			
			tailVisible(Data.useAlwaysHideArea)
			
			guard Data.useAlwaysHideArea else {
				return
			}
			
			let flag = self.collapsed && !self.idling && !self.mouseOver && popoverNotShown
			
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
			let flag = !(Helper.Keyboard.command && self.mouseOver) && popoverNotShown
			
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
	
	func headVisible(
		_ flag: Bool
	) {
		self.head.isVisible = flag
	}
	
	func separatorVisible(
		_ flag: Bool
	) {
		self.separator.isVisible = flag
	}
	
	func tailVisible(
		_ flag: Bool
	) {
		self.tail.isVisible = flag
	}
	
}
