//
//  QuotesViewController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad(
    ) {
        super.viewDidLoad()
    }
    
}

extension ViewController {
    
    // MARK: Storyboard instantiation
	
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
    
}

extension ViewController {
	
	// MARK: Actions
    
    @IBAction func quit(
        _ sender: NSButton
    ) {
		NSApplication.shared.terminate(sender)
    }
    
}
