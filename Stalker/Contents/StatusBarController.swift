//
//  StatusBarController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import AppKit

class StatusBarController {
	
	// MARK: - Constants
	
	static let NOTCH_DISABLED_AREA_WIDTH:	CGFloat = 250
	
	// MARK: - States
	
	var alphaValues: (h: CGFloat, s: CGFloat, t: CGFloat) = (h: -10, s: -32, t: -32) // For launching animations
	
	var available:				Bool = false
	
	var idling: 				Bool = false
	
	var idlingAlwaysHideArea: 	Bool = false
	
	
	
	var mouseOnStatusBar: 			Bool {
		guard
			let origin = head.button?.window?.frame.origin,
			let screenWidth = Helper.Screen.width,
			NSEvent.mouseLocation.x >= (Helper.Screen.hasNotch ? screenWidth / 2 : 0)
				&& NSEvent.mouseLocation.y >= origin.y
		else { return false }
		return true
	}
	
	var mouseOverAlwaysHideArea: 	Bool {
		guard let origin = tail.button?.window?.frame.origin else { return false }
		return NSEvent.mouseLocation.x <= origin.x
	}
	
	// MARK: - Timers & Event Monitors
	
	// Timers
	
	var animationTimer: Timer?
	
	var actionTimer: 	Timer?
	
	// Event monitors
	
	var mouseEventMonitor: EventMonitor?
	
	// MARK: - Rects
	
	var inside: NSRect? {
		if
			let originTail = tail.button?.window?.frame.origin,
			let originHead = head.button?.window?.frame.origin,
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
	
	// MARK: - Icons
	
	// Separator instances
	
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
	
	// Pointers specifying the separators' positions
	
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
	
	// MARK: - Inits
	
	init() {
		// _sep1 is the most left while _sep2 is the most right
		_seps = [_sep1, _sep2, _sep3]
		
		// Init status icons
		
		head.length 		= 0
		separator.length 	= 0
		tail.length 		= 0
		
		if let button = self.head.button {
			button.action = #selector(AppDelegate.toggle(_:))
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
		}
		
		if let button = self.separator.button {
			// button.action = #selector(AppDelegate.toggle(_:))
		}
		
		if let button = self.tail.button {
			// button.action = #selector(AppDelegate.toggle(_:))
		}
		
		// Start services
		
		startTimers()
		startMonitors()
	}
	
	deinit {
		stopTimers()
		stopMonitors()
	}
	
	// MARK: - Body
	
	private var lengths: 		(s: CGFloat, t: CGFloat) = (s: 0, t: 0)
	
	private var lastOriginXs: 	(s: CGFloat, t: CGFloat) = (s: 0, t: 0)
	
	private var lastFlags: 		(s: Bool, t: Bool) = (s: false, t: false)
	
	private var tailWasUnstable: 		Bool = false
	
	private var mouseWasOnStatusBar: 	Bool = false
	
	private var feedbackCount: Int = 0
	
	func update() {
		guard available else { return }
		
		if Data.collapsed && !idling && !idlingAlwaysHideArea && Data.autoShows && !(Helper.delegate?.popover.isShown ?? false)
			&&  ((!mouseWasOnStatusBar && mouseOnStatusBar) || (mouseWasOnStatusBar && !mouseOnStatusBar))
		{
			guard feedbackCount < Data.feedbackAttributes.1 else {
				mouseWasOnStatusBar = mouseOnStatusBar
				feedbackCount = 0
				return
			}
			feedbackCount += 1
			NSHapticFeedbackManager.defaultPerformer.perform(Data.feedbackAttributes.0, performanceTime: .now)
		}
		
		var borderX: CGFloat
		
		if let screenWidth = Helper.Screen.width, Helper.Screen.hasNotch {
			borderX = screenWidth / 2.0 + StatusBarController.NOTCH_DISABLED_AREA_WIDTH / 2.0
		} else { borderX = 20 }
		
		let popoverNotShown = !(Helper.delegate?.popover.isShown ?? false)
		
		// Head
		
		if let alpha = self.head.button?.alphaValue {
			self.head.button?.alphaValue = Helper.lerp(
				a: alpha,
				b: self.alphaValues.h,
				ratio: Animations.LERP_RATIO,
				false
			)
		}
		
		DispatchQueue.main.async {
			let flag = Data.collapsed && !(self.idling || self.idlingAlwaysHideArea) && (!Data.autoShows || !self.mouseOnStatusBar) && popoverNotShown
			
			Helper.lerpAsync(
				a: self.head.length,
				b: flag ? Data.theme.iconWidthAlt : Data.theme.iconWidth,
				ratio: Animations.LERP_RATIO
			) { result in
				self.head.length = result
			}
		}
		
		// Separator
		
		if let alpha = self.separator.button?.alphaValue {
			self.separator.button?.alphaValue = Helper.lerp(
				a: alpha,
				b: self.alphaValues.s,
				ratio: Animations.LERP_RATIO,
				false
			)
		}
		
		DispatchQueue.main.async {
			let flag = Data.collapsed && !(self.idling || self.idlingAlwaysHideArea) && (!Data.autoShows || !self.mouseOnStatusBar) && popoverNotShown
			
			guard let x = self.separator.origin?.x else { return }
			let length = self.separator.length
			
			if
				let origin = self.separator.origin,
				self.lastFlags.s != flag || origin.x != self.lastOriginXs.s
			{
				self.lengths.s = flag ? max(0, x + length - borderX) : Data.theme.iconWidth
				self.lastOriginXs.s = origin.x
				self.lastFlags.s = flag
			}
			
			if Data.reduceAnimation {
				self.separator.length = self.lengths.s
			} else {
				Helper.lerpAsync(
					a: length,
					b: self.lengths.s,
					ratio: Animations.LERP_RATIO
				) { result in
					self.separator.length = result
				}
			}
		}
		
		// Tail
		
		if let alpha = self.tail.button?.alphaValue {
			self.tail.button?.alphaValue =  Helper.lerp(
				a: alpha,
				b: self.alphaValues.t,
				ratio: Animations.LERP_RATIO,
				false
			)
		}
		
		DispatchQueue.main.async {
			let flag = !(Helper.Keyboard.command && self.mouseOnStatusBar) && !self.idlingAlwaysHideArea && popoverNotShown
			
			guard let x = self.tail.origin?.x else { return }
			let length = self.tail.length
			
			if !flag && !self.tailWasUnstable {
				if let origin = self.separator.origin, self.lengths.t <= 0 {
					self.lengths.t = origin.x - borderX
				}
				
				self.tail.length = self.lengths.t
				self.tailWasUnstable = true
				return
			} else if flag && !self.tailWasUnstable {
				self.tail.length = Helper.Screen.width ?? 10000
				return
			} else if self.tailWasUnstable {
				self.tailWasUnstable = !flag || self.tailWasUnstable && x > borderX
			}
			
			if
				let origin = self.tail.origin,
				self.lastFlags.t != flag || origin.x != self.lastOriginXs.t
			{
				self.lengths.t = flag ? max(0, x + length - borderX) : Data.theme.iconWidth
				self.lastOriginXs.t = origin.x
				self.lastFlags.t = flag
			}
			
			if Data.reduceAnimation {
				self.tail.length = self.lengths.t
			} else {
				Helper.lerpAsync(
					a: self.tail.length,
					b: self.lengths.t,
					ratio: Animations.LERP_RATIO
				) { result in
					self.tail.length = result
				}
			}
		}
		
		// Special judge for #remap()
		
		if !Data.theme.autoHideIcons {
			let popoverShown = Helper.delegate?.popover.isShown ?? false
			
			alphaValues.h = 1
			
			alphaValues.s = (
				popoverShown || !Data.collapsed
				|| idling || idlingAlwaysHideArea
				|| (Data.autoShows && mouseOnStatusBar)
			) ? 1 : 0
			
			alphaValues.t = (
				popoverShown || idling || idlingAlwaysHideArea
				|| Helper.Keyboard.command
			) ? 1 : 0
		}
	}
	
}

extension StatusBarController {
	
	// MARK: - Appearance Handlers
	
	func trigger(
		_ icon: NSStatusItem
	) -> NSRect? {
		if
			let origin = icon.origin,
			let screenHeight = Helper.Screen.height
		{
			return NSRect(
				x: 		origin.x,
				y: 		origin.y,
				width: 	Data.theme.iconWidth + 10 * 2,
				height: screenHeight - origin.y
			)
		} else {
			return nil
		}
	}
	
	func reorder() {
		guard available else {
			available = !(available && _seps.allSatisfy { sep in
				!sep.isVisible || sep.origin?.x ?? 0 != 0
			})
			return
		}
		
		saveSepsOrder(
			_seps.sorted {
				($0.isVisible ? ($0.origin?.x ?? 0) : 0) <= ($1.isVisible ? ($1.origin?.x ?? 0) : 0)
			}
		)
	}
	
	func remap() {
		guard available else { return }
		
		head.button?.image 		= Data.collapsed ? Data.theme.headCollapsed : Data.theme.headUncollapsed
		separator.button?.image = Data.theme.separator
		tail.button?.image 		= Data.theme.tail
		
		guard Data.autoShows || !Data.collapsed || !Data.theme.autoHideIcons else {
			alphaValues.h = 0
			alphaValues.s = 0
			alphaValues.t = 0
			return
		}
		
		let popoverShown = Helper.delegate?.popover.isShown ?? false
		
		if
			let headTrigger 		= trigger(head),
			let separatorTrigger 	= trigger(separator),
			let tailTrigger 		= trigger(tail),
			mouseOnStatusBar
				&& (idling || idlingAlwaysHideArea)
				&& (headTrigger.containsMouse || separatorTrigger.containsMouse || tailTrigger.containsMouse)
		{ unidle() }
		
		if !Data.theme.autoHideIcons {
			// Special judge. See #update()
		} else if popoverShown || (mouseOnStatusBar && (Helper.Keyboard.command || Helper.Keyboard.option)) {
			head.button?.image = Data.theme.headUncollapsed
			alphaValues.h = 1
			alphaValues.s = 1
			alphaValues.t = 1
		} else {
			alphaValues.h = !Data.collapsed ? 1 : 0
			alphaValues.s = 0
			alphaValues.t = 0
		}
	}
	
	func saveSepsOrder(
		_ currentSeps: [NSStatusItem]
	) {
		let sepsOrder: [Int?] = [_seps.firstIndex(of: currentSeps[0]),
								 _seps.firstIndex(of: currentSeps[1]),
								 _seps.firstIndex(of: currentSeps[2])]
		Data.sepsOrder = sepsOrder
	}
	
}
