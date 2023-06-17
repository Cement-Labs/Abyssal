//
//  StatusBarController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
	
	var collapsed: 	Bool = false
	
	var idling: 	Bool = false
	
	var sideIdling: Bool = false
	
	var animationTimer: Timer?
	
	var actionTimer: 	Timer?
	
	var mouseEventMonitor: EventMonitor?
	
	var mouseAvailable: Bool {
		guard
			let origin = head.button?.origin,
			let screenWidth = Helper.Screen.width,
			NSEvent.mouseLocation.x >= (Helper.Screen.hasNotch ? screenWidth / 2 : 0)
				&& NSEvent.mouseLocation.y >= origin.y
		else { return false }
		return true
	}
	
	var mouseSided: 	Bool {
		guard let origin = tail.button?.origin else { return false }
		return NSEvent.mouseLocation.x <= origin.x
	}
	
	// MARK: - Constants
	
	static let COLLAPSE_DISABLED_LENGTH: 	CGFloat = 2
	
	static let NOTCH_DISABLED_AREA_WIDTH:	CGFloat = 290
	
	static let HEAD_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepDot"))
	
	static let SEPARATOR_ICON: 	NSImage? = NSImage(named:NSImage.Name("SepLine"))
	
	static let TAIL_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepDottedLine"))
	
	static let EMPTY_ICON: 		NSImage? = NSImage(named:NSImage.Name("SepSpace"))
	
	// MARK: - Rects
	
	private var idle: NSRect? {
		if
			let originTail = tail.button?.origin,
			let originHead = head.button?.origin,
			let screenHeight = Helper.Screen.height
		{
			return NSRect(
				x: 		originTail.x + tail.length,
				y: 		originTail.y,
				width: 	originHead.x - (originTail.x + tail.length),
				height: screenHeight - originHead.y
			)
		} else {
			return nil
		}
	}
	
	private var headTrigger: NSRect? {
		if
			let origin = head.button?.origin,
			let screenHeight = Helper.Screen.height
		{
			return NSRect(
				x: 		origin.x,
				y: 		origin.y,
				width: 	head.length + 20,
				height: screenHeight - origin.y
			)
		} else {
			return nil
		}
	}
	
	private var separatorTrigger: NSRect? {
		if
			let origin = separator.button?.origin,
			let screenHeight = Helper.Screen.height
		{
			return NSRect(
				x: 		origin.x,
				y: 		origin.y,
				width: 	separator.length + 20,
				height: screenHeight - origin.y
			)
		} else {
			return nil
		}
	}
	
	private var tailTrigger: NSRect? {
		if
			let origin = tail.button?.origin,
			let screenHeight = Helper.Screen.height
		{
			return NSRect(
				x: 		origin.x,
				y: 		origin.y,
				width: 	tail.length + 20,
				height: screenHeight - origin.y
			)
		} else {
			return nil
		}
	}
	
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
		
		// Init status icons
		
		head.length 		= StatusBarController.COLLAPSE_DISABLED_LENGTH
		separator.length 	= 0
		tail.length 		= 0
		
		if let button = self.head.button {
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.separator.button {
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.tail.button {
			button.action 	= #selector(AppDelegate.toggle(_:))
		}
		
		// Start services
		
		startTimers()
		startMonitors()
	}
	
	deinit {
		stopTimers()
		stopMonitors()
	}
	
	// MARK: - Methods
	
	private func reorder() {
		guard _seps.allSatisfy ({ sep in
			sep.button?.origin?.x ?? 0 > 0
		}) else { return }
		
		saveSepsOrder(
			_seps.sorted {
				$0.button?.origin?.x ?? 0 < $1.button?.origin?.x ?? 0
			}
		)
	}
	
	private func remap() {
		head.button?.image = !collapsed ? StatusBarController.HEAD_ICON : StatusBarController.EMPTY_ICON
		
		if let trigger = headTrigger, 		mouseAvailable && (idling || sideIdling) && trigger.containsMouse { disableIdle() }

		if let trigger = separatorTrigger, 	mouseAvailable && (idling || sideIdling) && trigger.containsMouse { disableIdle() }
		
		if let trigger = tailTrigger, 		mouseAvailable && (idling || sideIdling) && trigger.containsMouse { disableIdle() }
		
		if mouseAvailable && (Helper.Keyboard.command || Helper.Keyboard.option) {
			head.button?.image 		= StatusBarController.HEAD_ICON
			separator.button?.image = StatusBarController.SEPARATOR_ICON
			tail.button?.image 		= StatusBarController.TAIL_ICON
		} else {
			separator.button?.image = StatusBarController.EMPTY_ICON
			tail.button?.image 		= StatusBarController.EMPTY_ICON
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
	
	func enableCollapse() {
		disableIdle()
		self.collapsed = true
	}
	
	func disableCollapse() {
		self.collapsed = false
		disableIdle()
	}
	
	func enableIdle() {
		self.idling = true
	}
	
	func disableIdle() {
		self.idling = false
		disableSideIdle()
	}
	
	func enableSideIdle() {
		self.sideIdling = true
	}
	
	func disableSideIdle() {
		self.sideIdling = false
	}
	
	func startTimers() {
		animationTimer = Timer.scheduledTimer(
			withTimeInterval: 1.0 / 60.0,
			repeats: true
		) { [weak self] _ in
			if let strongSelf = self {
				strongSelf.update()
			}
		}
		
		actionTimer = Timer.scheduledTimer(
			withTimeInterval: 1.0 / 10.0,
			repeats: true
		) { [weak self] _ in
			if let strongSelf = self {
				strongSelf.reorder()
				strongSelf.remap()
			}
		}
	}
	
	func stopTimers() {
		animationTimer?.invalidate()
		animationTimer = nil
		
		actionTimer?.invalidate()
		actionTimer = nil
	}
	
	func startMonitors() {
		mouseEventMonitor = EventMonitor(
			mask: [.leftMouseDown,
				   .rightMouseDown]
		) { [weak self] event in
			guard
				let strongSelf = self,
				let idle = strongSelf.idle,
				strongSelf.mouseAvailable
			else { return }
			
			if strongSelf.collapsed && idle.containsMouse && !Helper.Keyboard.command {
				strongSelf.enableIdle()
			}
			
			if strongSelf.mouseSided {
				strongSelf.enableSideIdle()
			}
		}
		
		mouseEventMonitor?.start()
	}
	
	func stopMonitors() {
		mouseEventMonitor?.stop()
	}
	
	private var lengths: [CGFloat] = [0, 0]
	
	private var lastOriginXs: [CGFloat] = [0, 0]
	
	private var lastFlags: [Bool] = [false, false]
	
	private func update() {
		var borderX: CGFloat
		
		if let screenWidth = Helper.Screen.width, Helper.Screen.hasNotch {
			borderX = screenWidth / 2.0 + StatusBarController.NOTCH_DISABLED_AREA_WIDTH / 2.0
		} else { borderX = 20 }
		
		let popoverNotShown = !(Helper.delegate?.popover.isShown ?? false)
		
		// Head
		
		DispatchQueue.global().async {
			let flag = self.collapsed && !(self.idling || self.sideIdling) && !self.mouseAvailable && popoverNotShown
			
			Helper.lerpAsync(
				a: self.head.length,
				b: StatusBarController.COLLAPSE_DISABLED_LENGTH * (flag ? 10.0 : 1.0),
				ratio: Animations.LERP_RATIO
			) { result in
				self.head.length = result
			}
		}
		
		// Separator
		
		DispatchQueue.global().async {
			let flag = self.collapsed && !(self.idling || self.sideIdling) && !self.mouseAvailable && popoverNotShown
			
			guard let x = self.separator.button?.origin?.x else { return }
			let length = self.separator.length
			
			if
				let origin = self.separator.button?.origin,
				self.lastFlags[0] != flag || origin.x != self.lastOriginXs[0]
			{
				self.lengths[0] = flag ? max(0, x + length - borderX) : StatusBarController.COLLAPSE_DISABLED_LENGTH
				self.lastOriginXs[0] = origin.x
				self.lastFlags[0] = flag
			}
			
			if Data.reduceAnimation {
				self.separator.length = self.lengths[0]
			} else {
				Helper.lerpAsync(
					a: length,
					b: self.lengths[0],
					ratio: Animations.LERP_RATIO
				) { result in
					self.separator.length = result
				}
			}
		}
		
		// Tail
		
		DispatchQueue.global().async {
			// Use always hide?
			
			self.tailVisible(Data.useAlwaysHideArea)
			guard Data.useAlwaysHideArea else { return }
			
			let flag = !(Helper.Keyboard.command && self.mouseAvailable) && !self.sideIdling && popoverNotShown
			
			if
				let origin = self.tail.button?.origin,
				self.lastFlags[1] != flag || origin.x != self.lastOriginXs[1]
			{
				self.lengths[1] = flag ? max(0, (Helper.Screen.width ?? 10000) - borderX) : StatusBarController.COLLAPSE_DISABLED_LENGTH
				self.lastOriginXs[1] = origin.x
				self.lastFlags[1] = flag
			}
			
			if Data.reduceAnimation {
				self.tail.length = self.lengths[1]
			} else {
				Helper.lerpAsync(
					a: self.tail.length,
					b: self.lengths[1],
					ratio: Animations.LERP_RATIO
				) { result in
					self.tail.length = result
				}
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
