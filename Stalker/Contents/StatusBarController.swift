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
	
	var alphaValues: 	(h: CGFloat, s: CGFloat, t: CGFloat) = (h: -10, s: -32, t: -32)
	
	var lengths: 		(h: CGFloat, s: CGFloat, t: CGFloat) = (h: 0, s: 0, t: 0)
	
	
	
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
	
	// MARK: - Rects
	
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
	
	var head: NSStatusItem {
		var order: Int = 2
		
		if let savedSepsOrder = Data.sepsOrder, let savedOrder = savedSepsOrder[order] {
			order = savedOrder
		}
		
		return _seps[order]
	}
	
	var body: NSStatusItem {
		var order: Int = 1
		
		if let savedSepsOrder = Data.sepsOrder, let savedOrder = savedSepsOrder[order] {
			order = savedOrder
		}
		
		return _seps[order]
	}
	
	var tail: NSStatusItem {
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
		
		head.length 		= lengths.h
		body.length 	= lengths.s
		tail.length 		= lengths.t
		
		if let button = self.head.button {
			button.action = #selector(AppDelegate.toggle(_:))
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
		}
		
		if let button = self.body.button {
			button.action = #selector(AppDelegate.toggleCollapse(_:))
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
		}
		
		if let button = self.tail.button {
			button.action = #selector(AppDelegate.toggleCollapse(_:))
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
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
	
	private var lastOriginXs: 	(s: CGFloat, t: CGFloat) = (s: 0, t: 0)
	
	private var lastFlags: 		(s: Bool, t: Bool) = (s: false, t: false)
	
	private var wasUnstable: 	(s: Bool, t: Bool) = (s: false, t: false)
	
	private var mouseWasOnStatusBarOrUnidled: 	Bool = false
	
	private var feedbackCount: Int = 0
	
	func update() {
		guard available else { return }
		
		// Process feedback
		
		if Data.collapsed && !idling && !idlingAlwaysHideArea && Data.autoShows && !(Helper.delegate?.popover.isShown ?? false)
			&&  !(idling && idlingAlwaysHideArea) && ((!mouseWasOnStatusBarOrUnidled && mouseOnStatusBar) || (mouseWasOnStatusBarOrUnidled && !mouseOnStatusBar))
		{
			guard feedbackCount < Data.feedbackAttributes.repeats else {
				mouseWasOnStatusBarOrUnidled = mouseOnStatusBar
				feedbackCount = 0
				return
			}
			feedbackCount += 1
			NSHapticFeedbackManager.defaultPerformer.perform(Data.feedbackAttributes.pattern, performanceTime: .now)
		}
		
		// Modify basic appearance
		
		head.button?.appearsDisabled 		= !Data.theme.autoHideIcons && !Data.collapsed
		body.button?.appearsDisabled 	= !Data.theme.autoHideIcons && !Data.collapsed
		tail.button?.appearsDisabled 		= !Data.theme.autoHideIcons && !Data.collapsed
		
		
		// Calculate border
		
		let maxWidth = Helper.Screen.maxWidth ?? 10000 // To cover all screens
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
				ratio: StatusBarController.lerpRatio,
				false
			)
		}
		
		DispatchQueue.main.async {
			let flag = popoverNotShown && Data.collapsed && !(self.idling || self.idlingAlwaysHideArea) && (!Data.autoShows || !self.mouseOnStatusBar)
			
			self.lengths.h = flag ? Data.theme.iconWidthAlt : Data.theme.iconWidth
			
			Helper.lerpAsync(
				a: self.head.length,
				b: self.lengths.h,
				ratio: StatusBarController.lerpRatio
			) { result in
				self.head.length = result
			}
		}
		
		// Separator
		
		if let alpha = self.body.button?.alphaValue {
			self.body.button?.alphaValue = Helper.lerp(
				a: alpha,
				b: self.alphaValues.s,
				ratio: StatusBarController.lerpRatio,
				false
			)
		}
		
		DispatchQueue.main.async {
			let flag = popoverNotShown && Data.collapsed && !(self.idling || self.idlingAlwaysHideArea) && (!Data.autoShows || !self.mouseOnStatusBar)
			
			guard let x = self.body.origin?.x else { return }
			let length = self.body.length
			
			if !flag && !self.wasUnstable.s {
				if self.lengths.s <= 0 { self.lengths.s = x + length - borderX }
				
				self.body.length = self.lengths.s
				self.wasUnstable.s = true
				return
			} else if flag && !self.wasUnstable.s {
				self.body.length = maxWidth
				return
			} else if self.wasUnstable.s {
				self.wasUnstable.s = !flag || self.wasUnstable.s && x > borderX + 5
			}
			
			if
				let origin = self.body.origin,
				self.lastFlags.s != flag || origin.x != self.lastOriginXs.s
			{
				self.lengths.s = flag ? max(0, x + length - borderX) : Data.theme.iconWidth
				self.lastOriginXs.s = origin.x
				self.lastFlags.s = flag
			}
			
			if Data.reduceAnimation {
				self.body.length = self.lengths.s
			} else {
				Helper.lerpAsync(
					a: length,
					b: self.lengths.s,
					ratio: StatusBarController.lerpRatio
				) { result in
					self.body.length = result
				}
			}
		}
		
		// Tail
		
		if let alpha = self.tail.button?.alphaValue {
			self.tail.button?.alphaValue =  Helper.lerp(
				a: alpha,
				b: self.alphaValues.t,
				ratio: StatusBarController.lerpRatio,
				false
			)
		}
		
		DispatchQueue.main.async {
			let flag = !(Helper.Keyboard.command && ((Data.collapsed && !self.idling) || self.mouseOnStatusBar)) && !self.idlingAlwaysHideArea && popoverNotShown
			
			guard let x = self.tail.origin?.x else { return }
			let length = self.tail.length
			
			if !flag && !self.wasUnstable.t {
				if self.lengths.t <= 0 { self.lengths.t = x + length - borderX }
				
				self.tail.length = self.lengths.t
				self.wasUnstable.t = true
				return
			} else if flag && !self.wasUnstable.t {
				self.tail.length = maxWidth
				return
			} else if self.wasUnstable.t {
				self.wasUnstable.t = !flag || self.wasUnstable.t && x > borderX + 5
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
					ratio: StatusBarController.lerpRatio
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
				popoverShown || idlingAlwaysHideArea
				|| (mouseOnStatusBar && (Helper.Keyboard.command || Helper.Keyboard.option))
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
		body.button?.image = Data.theme.separator
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
			let separatorTrigger 	= trigger(body),
			let tailTrigger 		= trigger(tail),
			mouseOnStatusBar
				&& (idling || idlingAlwaysHideArea)
				&& (headTrigger.containsMouse || separatorTrigger.containsMouse || tailTrigger.containsMouse)
		{
			unidleHideArea()
			mouseWasOnStatusBarOrUnidled = false
		}
		
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
