//
//  QuotesViewController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class ViewController: NSViewController, NSMenuDelegate {
	
	var quitAppTrackingArea: NSTrackingArea?
	
	var stalkerTrackingArea: NSTrackingArea?
	
	let themesMenu: NSMenu = NSMenu()
	
	// MARK: - Constants
	
	static let QUIT_APP_MIN_HEIGHT: CGFloat = 10
	
	static let QUIT_APP_MAX_HEIGHT: CGFloat = 32
	
	static let INFO_SHIFT: CGFloat = 8
	
	// MARK: - Outlets
	
	@IBOutlet var main: NSView!
	
	
	
	@IBOutlet weak var update: 		NSBox!
	
	@IBOutlet weak var version: 	NSBox!
	
	@IBOutlet weak var sourceCode: 	NSBox!
	
	@IBOutlet weak var info: 		NSBox!
	
	@IBOutlet weak var preferences: NSBox!
	
	
	
	@IBOutlet weak var updateButton: 		NSButton!
	
	@IBOutlet weak var updateIcon: 			NSImageView!
	
	@IBOutlet weak var versionButton: 		NSButton!
	
	@IBOutlet weak var sourceCodeButton: 	NSButton!
	
	@IBOutlet weak var logo: NSImageView!
	
	
	
	@IBOutlet weak var stalker: NSTextField!
	
	@IBOutlet weak var stalkerPlaceholder: NSBox!
	
	
	
	@IBOutlet weak var quitApp: NSBox!
	
	@IBOutlet weak var quitAppPlaceholder: NSBox!
	
	@IBOutlet weak var quitAppButton: NSButton!
	
	
	
	@IBOutlet weak var feedbackIntensityLabel: NSTextField!
	
	@IBOutlet weak var feedbackIntensity: NSSlider!
	
	
	
	@IBOutlet weak var themes: NSPopUpButton!
	
	
	
	
	@IBOutlet weak var autoShows: 					NSSwitch!
	
	@IBOutlet weak var useAlwaysHideArea: 			NSSwitch!
	
	@IBOutlet weak var reduceAnimation: 			NSSwitch!
	
	@IBOutlet weak var startsWithMacos: 			NSSwitch!
	
	// MARK: - View Methods
	
	override func viewDidLoad(
	) {
		super.viewDidLoad()
		
		updateData()
		
		// Init version info
		
		do {
			updateVersionInfo()
			
			updateButton.title = String.localizedStringWithFormat(
				NSLocalizedString(
					"Update Available - Version %1$@ → %2$@",
					comment: "Version info with an update available"
				),
				Helper.version ?? "?",
				Helper.versionComponent.version
			)
			
			versionButton.title = String.localizedStringWithFormat(
				NSLocalizedString(
					"Version %@",
					comment: "Version info"
				),
				Helper.version ?? "?"
			)
		}
		
		// Init tracking areas
		
		quitAppTrackingArea = NSTrackingArea(
			rect: 		quitAppPlaceholder.bounds,
			options: 	[.mouseEnteredAndExited,
						 .activeInActiveApp],
			owner: 		self,
			userInfo: 	["area": "quitApp"]
		)
		
		quitApp.addTrackingArea(quitAppTrackingArea!)
		
		stalkerTrackingArea = NSTrackingArea(
			rect: 		stalkerPlaceholder.bounds,
			options: 	[.mouseEnteredAndExited,
						 .activeInActiveApp],
			owner: 		self,
			userInfo: 	["area": "stalker"]
		)
		
		stalker.addTrackingArea(stalkerTrackingArea!)
		
		// Init main view
		
		stalker.alphaValue = 1
		
		adjustInfoAlpha(0)
		
		shiftInfoFrameOrigin(
			CGAffineTransform(
				translationX: 0,
				y: ViewController.INFO_SHIFT
			)
		)
		
		main.setFrameSize(
			NSSize(
				width:	main.frame.width,
				height: main.frame.height + ViewController.QUIT_APP_MIN_HEIGHT - ViewController.QUIT_APP_MAX_HEIGHT
			)
		)
		
		main.setBoundsOrigin(
			main.bounds.origin.applying(
				CGAffineTransform(
					translationX: 0,
					y: ViewController.QUIT_APP_MAX_HEIGHT - ViewController.QUIT_APP_MIN_HEIGHT
				)
			)
		)
		
		// Init quit app box
		
		quitApp.setFrameSize(
			NSSize(
				width: 	quitApp.frame.width,
				height: ViewController.QUIT_APP_MIN_HEIGHT
			)
		)
		
		quitApp.setFrameOrigin(
			quitApp.frame.origin.applying(
				CGAffineTransform(
					translationX: 0,
					y: ViewController.QUIT_APP_MAX_HEIGHT - ViewController.QUIT_APP_MIN_HEIGHT
				)
			)
		)
		
		// Init quit app button
		
		quitAppButton.alphaValue = 0
	}
	
	override func viewDidAppear() {
		Helper.CHECK_NEWER_VERSION_TASK.resume()
	}
	
}

extension ViewController {
	
	// MARK: - Themes Menu Delegate
	
	@objc func menu(
		_ menu: NSMenu,
		willHighlight menuItem: NSMenuItem?
	) {
		if
			let menuItem = menuItem,
			let _ = themes.menu?.items.firstIndex(of: menuItem)
		{
			// Doesn't work for now
		}
	}
	
	@objc func menuDidClose(
		_ menu: NSMenu
	) {
		if let menuItem = themes.menu?.highlightedItem,
		   let index = themes.menu?.items.firstIndex(of: menuItem)
		{
			Data.theme = Themes.themes[index]
            Helper.delegate?.statusBarController.startFunctionalTimers()
            Helper.delegate?.statusBarController.map()
		}
	}
	
}

extension ViewController {
	
	// MARK: - Storyboard Instantiation
	
	static func freshController() -> ViewController {
		let storyboard = NSStoryboard(
			name: NSStoryboard.Name("Main"),
			bundle: nil
		)
		
		let identifier = NSStoryboard.SceneIdentifier("ViewController")
		
		guard let controller = storyboard.instantiateController(
			withIdentifier: identifier
		) as? ViewController else {
			fatalError("Can not find ViewController")
		}
		
		return controller
	}
	
}

extension ViewController {
	
	func updateVersionInfo() {
		updateButton.isHidden		= !Helper.versionComponent.needsUpdate
		updateIcon.isHidden			= !Helper.versionComponent.needsUpdate
		
		sourceCodeButton.isHidden 	= Helper.versionComponent.needsUpdate
		versionButton.isHidden 		= Helper.versionComponent.needsUpdate
		logo.isHidden 				= Helper.versionComponent.needsUpdate
	}
	
	func updateData() {
		// Init themes menu
		
		do {
			themes.removeAllItems()
			themes.addItems(withTitles: Themes.themeNames)
			themes.menu?.delegate = self
			
			if let index = Themes.themes.firstIndex(of: Data.theme) {
				themes.selectItem(at: index)
			}
			
			var maxWidth: CGFloat = 0
			if let menu = themes.menu {
				for item in menu.items {
					let size = NSAttributedString(string: item.title).size()
					maxWidth = max(maxWidth, size.width)
				}
				
				themes.widthAnchor.constraint(equalToConstant: maxWidth + 65).isActive = true
			}
		}
		
		// Init controls
		
		autoShows.set(Data.autoShows)
		feedbackIntensity.objectValue = Data.feedbackIntensity
		feedBackIntensityEnabled(Data.autoShows)
		
		useAlwaysHideArea	.set(Data.useAlwaysHideArea)
		reduceAnimation		.set(Data.reduceAnimation)
		
		startsWithMacos		.set(Data.startsWithMacos)
	}
	
	func adjustInfoAlpha(
		_ alpha: CGFloat,
		_ animated: Bool = false
	) {
		if animated {
			update.animator().alphaValue 		= alpha
			version.animator().alphaValue 		= alpha
			sourceCode.animator().alphaValue 	= alpha
			info.animator().alphaValue 			= alpha
		} else {
			update.alphaValue 		= alpha
			version.alphaValue 		= alpha
			sourceCode.alphaValue 	= alpha
			info.alphaValue 		= alpha
		}
	}
	
	func shiftInfoFrameOrigin(
		_ applying: CGAffineTransform,
		_ animated: Bool = false
	) {
		if animated {
			update		.animator().setFrameOrigin(update		.frame.origin.applying(applying))
			version		.animator().setFrameOrigin(version		.frame.origin.applying(applying))
			sourceCode	.animator().setFrameOrigin(sourceCode	.frame.origin.applying(applying))
			info		.animator().setFrameOrigin(info			.frame.origin.applying(applying))
		} else {
			update		.setFrameOrigin(update		.frame.origin.applying(applying))
			version		.setFrameOrigin(version		.frame.origin.applying(applying))
			sourceCode	.setFrameOrigin(sourceCode	.frame.origin.applying(applying))
			info		.setFrameOrigin(info		.frame.origin.applying(applying))
		}
	}
	
	func feedBackIntensityEnabled(
		_ flag: Bool
	) {
		feedbackIntensity.isEnabled = flag
		feedBackIntensityLabelEnabled(flag && Data.feedbackIntensity > 0)
	}
	
	func feedBackIntensityLabelEnabled(
		_ flag: Bool
	) {
		feedbackIntensityLabel.textColor = flag ? NSColor.labelColor : NSColor.disabledControlTextColor
	}
	
}

extension ViewController {
	
	// MARK: - Tracking Areas
	
	override func mouseEntered(
		with event: NSEvent
	) {
		super.mouseEntered(with: event)
		
		if let userInfo = event.trackingArea?.userInfo as? [String : String], let area = userInfo["area"] {
			switch area {
			case "quitApp":
				
				main.animator().setFrameOrigin(
					main.frame.origin.applying(
						CGAffineTransform(
							translationX: 0,
							y: ViewController.QUIT_APP_MAX_HEIGHT - ViewController.QUIT_APP_MIN_HEIGHT
						)
					)
				)
				
				quitApp.animator().setFrameSize(
					NSSize(
						width: 	quitApp.frame.width,
						height: ViewController.QUIT_APP_MAX_HEIGHT
					)
				)
				
				quitApp.animator().setFrameOrigin(
					quitApp.frame.origin.applying(
						CGAffineTransform(
							translationX: 0,
							y: ViewController.QUIT_APP_MIN_HEIGHT - ViewController.QUIT_APP_MAX_HEIGHT
						)
					)
				)
				
				quitAppButton	.animator().alphaValue = 1
				stalker			.animator().alphaValue = 0
				
				// Preferences filters
				
				do {
					let blur = CIFilter(name: "CIGaussianBlur")
					blur?.setValue(8, forKey: kCIInputRadiusKey)
					
					preferences.animator().contentFilters = [blur!]
				}
				
			case "stalker":
				
				stalker.animator().alphaValue = 0.55
				
				adjustInfoAlpha(1, true)
				
				shiftInfoFrameOrigin(
					CGAffineTransform(
						translationX: 0,
						y: -ViewController.INFO_SHIFT
					), true
				)
				
				// Stalker filters
				
				do {
					let blur = CIFilter(name: "CIGaussianBlur")
					blur?.setValue(16, forKey: kCIInputRadiusKey)
					
					let halftone = CIFilter(name: "CICMYKHalftone")
					halftone?.setValue(6, 		forKey: kCIInputWidthKey)
					halftone?.setValue(0, 		forKey: kCIInputAngleKey)
					halftone?.setValue(0.2, 	forKey: kCIInputSharpnessKey)
					halftone?.setValue(1, 		forKey: "inputGCR")
					halftone?.setValue(0.75, 	forKey: "inputUCR")
					
					stalker.animator().contentFilters = [blur!, halftone!]
				}
				
				// Version info
				
				do {
					updateVersionInfo()
					
					if
						updateIcon.layer?.animationKeys()?.isEmpty == nil
							|| updateIcon.layer?.animationKeys()?.isEmpty == true
					{
						updateIcon.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
						
						if let origin = updateIcon.layer?.frame.origin {
							updateIcon.layer?.frame.origin = origin.applying(
								CGAffineTransform(
									translationX: 	(updateIcon.layer?.frame.width ?? 0) / 2,
									y: 				(updateIcon.layer?.frame.height ?? 0) / 2
								)
							)
						}
						
						let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
						
						rotationAnimation.fromValue = 0
						rotationAnimation.toValue = 2 * Double.pi
						rotationAnimation.duration = 1.0
						
						rotationAnimation.repeatCount = Float.infinity
						
						updateIcon.layer?.add(rotationAnimation, forKey: "rotationAnimation")
					}
				}
				
			default:
				break
			}
		}
	}
	
	override func mouseExited(
		with event: NSEvent
	) {
		super.mouseEntered(with: event)
		
		if let userInfo = event.trackingArea?.userInfo as? [String : String], let area = userInfo["area"] {
			switch area {
			case "quitApp":
				
				main.animator().setFrameOrigin(
					main.frame.origin.applying(
						CGAffineTransform(
							translationX: 0,
							y: ViewController.QUIT_APP_MIN_HEIGHT - ViewController.QUIT_APP_MAX_HEIGHT
						)
					)
				)
				
				quitApp.animator().setFrameSize(
					NSSize(
						width: 	quitApp.frame.width,
						height: ViewController.QUIT_APP_MIN_HEIGHT
					)
				)
				
				quitApp.animator().setFrameOrigin(
					quitApp.frame.origin.applying(
						CGAffineTransform(
							translationX: 0,
							y: ViewController.QUIT_APP_MAX_HEIGHT - ViewController.QUIT_APP_MIN_HEIGHT
						)
					)
				)
				
				quitAppButton	.animator().alphaValue = 0
				stalker			.animator().alphaValue = 1
				
				preferences.animator().contentFilters = []
				
			case "stalker":
				
				stalker	.animator().alphaValue = 1
				
				adjustInfoAlpha(0, true)
				
				shiftInfoFrameOrigin(
					CGAffineTransform(
						translationX: 0,
						y: ViewController.INFO_SHIFT
					), true
				)
				
				stalker.animator().contentFilters = []
				
			default:
				break
			}
		}
	}
}

extension ViewController {
	
	// MARK: - Global Actions
	
	@IBAction func triggerSourceCode(
		_ sender: NSButton
	) {
		Helper.delegate?.togglePopover(sender)
		NSWorkspace.shared.open(Helper.SOURCE_CODE_URL)
	}
	
	@IBAction func triggerCheckUpdate(
		_ sender: NSButton
	) {
		Helper.CHECK_NEWER_VERSION_TASK.resume()
		updateVersionInfo()
	}
	
	@IBAction func triggerUpdate(
		_ sender: NSButton
	) {
		Helper.delegate?.togglePopover(sender)
		NSWorkspace.shared.open(Helper.RELEASE_URL)
	}
	
	@IBAction func quit(
		_ sender: NSButton
	) {
		NSApplication.shared.terminate(sender)
	}
	
	// MARK: - Data Actions
	
	@IBAction func toggleAutoShows(
		_ sender: NSSwitch
	) {
		Data.autoShows = sender.flag
		feedBackIntensityEnabled(sender.flag)
	}
    
    @IBAction func toggleFeedbackIntensity(
        _ sender: NSSlider
    ) {
        Data.feedbackIntensity = sender.integerValue
        feedBackIntensityLabelEnabled(sender.integerValue > 0)
    }
    
    
	
	@IBAction func toggleUseAlwaysHideArea(
		_ sender: NSSwitch
	) {
		Data.useAlwaysHideArea = sender.flag
		Helper.delegate?.statusBarController.untilTailVisible(sender.flag)
	}
	
	@IBAction func toggleReduceAnimation(
		_ sender: NSSwitch
	) {
		Data.reduceAnimation = sender.flag
	}
	
    
	
	@IBAction func toggleStartsWithMacos(
		_ sender: NSSwitch
	) {
		Data.startsWithMacos = sender.flag
	}
	
}
