//
//  QuotesViewController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class ViewController: NSViewController {
	
	// MARK: - Constants
	
	static let QUIT_APP_MIN_HEIGHT: CGFloat = 10
	
	static let QUIT_APP_MAX_HEIGHT: CGFloat = 32
	
	// MARK: - Outlets
	
	@IBOutlet var main: NSView!
	
	@IBOutlet weak var quitApp: NSBox!
	
	@IBOutlet weak var quitAppPlaceholder: NSBox!
	
	@IBOutlet weak var quitAppButton: NSButton!
	
	var trackingArea: NSTrackingArea?
	
	@IBOutlet weak var autoHidesAfterTimeout: NSSwitch!
	
	@IBOutlet weak var useAlwaysHideArea: NSSwitch!
	
	@IBOutlet weak var startsWithMacos: NSSwitch!
	
    override func viewDidLoad(
    ) {
        super.viewDidLoad()
		
		updateData()
		
		let options: NSTrackingArea.Options = [.mouseEnteredAndExited,
											   .activeInActiveApp]
		trackingArea = NSTrackingArea(
			rect: quitAppPlaceholder.bounds,
			options: options,
			owner: self,
			userInfo: nil
		)
		
		quitApp.addTrackingArea(trackingArea!)
		
		// Init main view
		
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
		autoHidesAfterTimeout	.set(Data.autoHidesAfterTimeout)
		useAlwaysHideArea		.set(Data.useAlwaysHideArea)
		startsWithMacos			.set(Data.startsWithMacos)
	}
	
}

extension ViewController {
	override func mouseEntered(
		with event: NSEvent
	) {
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
			
			quitAppButton.animator().alphaValue = 1
		})
	}

	override func mouseExited(
		with event: NSEvent
	) {
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
			
			quitAppButton.animator().alphaValue = 0
		})
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
	
	@IBAction func autoHidesAfterTimeout(
		_ sender: NSSwitch
	) {
		Data.autoHidesAfterTimeout 	= sender.flag
	}
	
	@IBAction func useAlwaysHideArea(
		_ sender: NSSwitch
	) {
		Data.useAlwaysHideArea 		= sender.flag
		
		if sender.flag {
			AppDelegate.statusBarController.showTail()
		} else {
			AppDelegate.statusBarController.hideTail()
		}
	}
	
	@IBAction func startsWithMacos(
		_ sender: NSSwitch
	) {
		Data.startsWithMacos 		= sender.flag
	}
    
}
