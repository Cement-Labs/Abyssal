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
	
	
	
	var inInsufficientSpace: Bool {
		guard
			let origin = separator.button?.window?.frame.origin,
			let screenWidth = Helper.Screen.width
		else { return false }
		return origin.x + separator.length <= (Helper.Screen.hasNotch ? screenWidth / 2 + StatusBarController.NOTCH_DISABLED_AREA_WIDTH / 2 : 0)
	}
	
	// MARK: - Timers & Event Monitors
	
	// Timers
	
	var animationTimer: Timer?
	
	var actionTimer: 	Timer?
	
	// Event monitors
	
	var mouseEventMonitor: EventMonitor?
	
	// MARK: - Rects
	
	var inside: 				NSRect? {
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
		
		head.length 		= Data.theme.iconWidth
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
	
	// MARK: - Body
	
	private var lengths: [CGFloat] = [0, 0]
	
	private var lastOriginXs: [CGFloat] = [0, 0]
	
	private var lastFlags: [Bool] = [false, false]
	
	private var mouseWasOnStatusBar: Bool = false
	
	private var lastFeedback: Int = 0
	
	func update() {
		guard available else { return }
		
		guard !inInsufficientSpace else {
			head.length 		= 0
			separator.length 	= 0
			tail.length 		= 0
			return
		}
		
		if
			Data.collapsed && !idling && !idlingAlwaysHideArea && Data.autoShows && !(Helper.delegate?.popover.isShown ?? false) &&  (
				(!mouseWasOnStatusBar && mouseOnStatusBar)
				|| (mouseWasOnStatusBar && !mouseOnStatusBar)
			)
		{
			guard lastFeedback <= Data.feedbackAttributes.1 else {
				mouseWasOnStatusBar = mouseOnStatusBar
				lastFeedback = 0
				return
			}
			lastFeedback += 1
			NSHapticFeedbackManager.defaultPerformer.perform(Data.feedbackAttributes.0, performanceTime: .now)
		}
		
		var borderX: CGFloat
		
		if let screenWidth = Helper.Screen.width, Helper.Screen.hasNotch {
			borderX = screenWidth / 2.0 + StatusBarController.NOTCH_DISABLED_AREA_WIDTH / 2.0
		} else { borderX = 20 }
		
		let popoverNotShown = !(Helper.delegate?.popover.isShown ?? false)
		
		// Head
		
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
		
		DispatchQueue.main.async {
			let flag = Data.collapsed && !(self.idling || self.idlingAlwaysHideArea) && (!Data.autoShows || !self.mouseOnStatusBar) && popoverNotShown
			
			guard let x = self.separator.origin?.x else { return }
			let length = self.separator.length
			
			if
				let origin = self.separator.origin,
				self.lastFlags[0] != flag || origin.x != self.lastOriginXs[0]
			{
				self.lengths[0] = flag ? max(0, x + length - borderX) : Data.theme.iconWidth
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
		
		DispatchQueue.main.async {
			let flag = !(Helper.Keyboard.command && self.mouseOnStatusBar) && !self.idlingAlwaysHideArea && popoverNotShown
			
			if
				let origin = self.tail.origin,
				self.lastFlags[1] != flag || origin.x != self.lastOriginXs[1]
			{
				self.lengths[1] = flag ? max(0, (Helper.Screen.width ?? 10000) - borderX) : Data.theme.iconWidth
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
	
}

extension StatusBarController {
	
	// MARK: - Appearance Handlers
	
	func trigger(
		_ icon: NSStatusItem
	) -> NSRect? {
		if
			let origin = icon.origin,
			let screenHeight = Helper.Screen.height,
			let width = icon.button?.frame.width
		{
			return NSRect(
				x: 		origin.x,
				y: 		origin.y,
				width: 	width + 20,
				height: screenHeight - origin.y
			)
		} else {
			return nil
		}
	}
	
	func reorder() {
		guard available else {
			available = !(available && _seps.allSatisfy({ sep in
				!sep.isVisible || sep.origin?.x ?? 0 != 0
			}))
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
		
		guard Data.autoShows || !Data.collapsed else {
			head.button?.image		= Themes.Theme.EMPTY
			separator.button?.image = Themes.Theme.EMPTY
			tail.button?.image 		= Themes.Theme.EMPTY
			return
		}
		
		let popoverShown = Helper.delegate?.popover.isShown ?? false
		
		head.button?.image = Data.collapsed ? Data.theme.headCollapsed : Data.theme.headUncollapsed
		
		if
			let headTrigger 		= trigger(head),
			let separatorTrigger 	= trigger(separator),
			let tailTrigger 		= trigger(tail),
			mouseOnStatusBar
				&& (idling || idlingAlwaysHideArea)
				&& (
					headTrigger.containsMouse
					|| separatorTrigger.containsMouse
					|| tailTrigger.containsMouse
				)
		{ unidle() }
		
		if !Data.theme.autoHideIcons {
			separator.button?.image = Data.theme.separator
			tail.button?.image 		= Data.theme.tail
		} else if popoverShown || (mouseOnStatusBar && (Helper.Keyboard.command || Helper.Keyboard.option)) {
			head.button?.image 		= Data.theme.headUncollapsed
			separator.button?.image = Data.theme.separator
			tail.button?.image 		= Data.theme.tail
		} else {
			separator.button?.image = Themes.Theme.EMPTY
			tail.button?.image 		= Themes.Theme.EMPTY
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
