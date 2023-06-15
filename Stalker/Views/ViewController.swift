//
//  QuotesViewController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class ViewController: NSViewController {
	
	var quitAppTrackingArea: NSTrackingArea?
	
	var stalkerTrackingArea: NSTrackingArea?
	
	// MARK: - Constants
	
	static let QUIT_APP_MIN_HEIGHT: CGFloat = 10
	
	static let QUIT_APP_MAX_HEIGHT: CGFloat = 32
	
	// MARK: - Outlets
	
	@IBOutlet var main: NSView!
	
	@IBOutlet weak var info: NSBox!
	
	
	
	@IBOutlet weak var stalker: NSTextField!
	
	@IBOutlet weak var stalkerPlaceholder: NSBox!
	
	
	
	@IBOutlet weak var quitApp: NSBox!
	
	@IBOutlet weak var quitAppPlaceholder: NSBox!
	
	@IBOutlet weak var quitAppButton: NSButton!
	
	
	
	@IBOutlet weak var autoHides: 			NSSwitch!
	
	@IBOutlet weak var useAlwaysHideArea: 	NSSwitch!
	
	@IBOutlet weak var startsWithMacos: 	NSSwitch!
	
	@IBOutlet weak var reduceAnimation: 	NSSwitch!
	
    override func viewDidLoad(
    ) {
        super.viewDidLoad()
		
		updateData()
		
		// Init tracking areas
		
		let options: NSTrackingArea.Options = [.mouseEnteredAndExited,
											   .activeInActiveApp]
		
		quitAppTrackingArea = NSTrackingArea(
			rect: 		quitAppPlaceholder.bounds,
			options: 	options,
			owner: 		self,
			userInfo: 	["area": 1]
		)
		
		quitApp.addTrackingArea(quitAppTrackingArea!)
		
		stalkerTrackingArea = NSTrackingArea(
			rect: 		stalkerPlaceholder.bounds,
			options: 	options,
			owner: 		self,
			userInfo: 	["area": 2]
		)
		
		stalker.addTrackingArea(stalkerTrackingArea!)
		
		// Init main view
		
		info.alphaValue = 0
		stalker.alphaValue = 1
		
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
    
}

extension ViewController {
    
    // MARK: - Storyboard Instantiation
	
    static func freshController(
    ) -> ViewController {
        let storyboard = NSStoryboard(
            name: NSStoryboard.Name("Main"),
            bundle: nil
        )
        
        let identifier = NSStoryboard.SceneIdentifier("ViewController")
        
        guard let viewcontroller = storyboard.instantiateController(
            withIdentifier: identifier
        ) as? ViewController else {
            fatalError("Can not find ViewController")
        }
		
        return viewcontroller
    }
	
	func updateData() {
		autoHides			.set(Data.autoHides)
		useAlwaysHideArea	.set(Data.useAlwaysHideArea)
		startsWithMacos		.set(Data.startsWithMacos)
		reduceAnimation		.set(Data.reduceAnimation)
	}
	
}

extension ViewController {
	
	// MARK: - Tracking Areas
	
	override func mouseEntered(
		with event: NSEvent
	) {
		super.mouseEntered(with: event)
		
		if let userInfo = event.trackingArea?.userInfo as? [String: Int], let area = userInfo["area"] {
			switch area {
			case 1: // Quit app
				
				NSAnimationContext.runAnimationGroup({ context in
					context.duration = Animations.Time.QUIT_APP_EXPAND
					
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
				})
				
			case 2: // Stalker
				
				info	.animator().alphaValue = 1
				stalker	.animator().alphaValue = 0.55
				
				let blur = CIFilter(name: "CIDiscBlur")
				blur?.setValue(8, forKey: kCIInputRadiusKey)
				
				let halftone = CIFilter(name: "CICMYKHalftone")
				halftone?.setValue(6, 		forKey: kCIInputWidthKey)
				halftone?.setValue(0, 		forKey: kCIInputAngleKey)
				halftone?.setValue(0.2, 	forKey: kCIInputSharpnessKey)
				halftone?.setValue(1, 		forKey: "inputGCR")
				halftone?.setValue(0.75, 	forKey: "inputUCR")
				
				stalker.animator().contentFilters = [blur!, halftone!]
				
			default:
				break
			}
		}
	}

	override func mouseExited(
		with event: NSEvent
	) {
		super.mouseEntered(with: event)
		
		if let userInfo = event.trackingArea?.userInfo as? [String: Int], let area = userInfo["area"] {
			switch area {
			case 1: // Quit app
				
				NSAnimationContext.runAnimationGroup({ context in
					context.duration = Animations.Time.QUIT_APP_EXPAND
					
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
				})
				
			case 2: // Stalker
				
				info	.animator().alphaValue = 0
				stalker	.animator().alphaValue = 1
				
				stalker.animator().contentFilters = []
				
			default:
				break
			}
		}
	}
}

extension ViewController {
	
	// MARK: - Global Actions
    
    @IBAction func quit(
        _ sender: NSButton
    ) {
		NSApplication.shared.terminate(sender)
    }
	
	// MARK: - Data Actions
	
	@IBAction func autoHides(
		_ sender: NSSwitch
	) {
		Data.autoHides 			= sender.flag
	}
	
	@IBAction func useAlwaysHideArea(
		_ sender: NSSwitch
	) {
		Data.useAlwaysHideArea 	= sender.flag
		
		if let appDelegate = Helper.delegate {
			if sender.flag {
				appDelegate.statusBarController.showTail()
			} else {
				appDelegate.statusBarController.hideTail()
			}
		}
	}
	
	@IBAction func startsWithMacos(
		_ sender: NSSwitch
	) {
		Data.startsWithMacos 	= sender.flag
	}
	
	@IBAction func reduceAnimation(
		_ sender: NSSwitch
	) {
		Data.reduceAnimation	= sender.flag
	}
	
	@IBAction func inspectSourceCode(
		_ sender: NSButton
	) {
		if let url = Helper.SOURCE_CODE_URL {
			NSWorkspace.shared.open(url)
		}
	}
	
	@IBAction func sponsor(
		_ sender: NSButton
	) {
		if let url = Helper.SPONSOR_URL {
			NSWorkspace.shared.open(url)
		}
	}
    
}
