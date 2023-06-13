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
        // Do view setup here.
    }
    
}

extension ViewController {
    
    // MARK: Storyboard instantiation
    static func freshController(
    ) -> ViewController {
        //1.
        let storyboard = NSStoryboard(
            name: NSStoryboard.Name("Main"),
            bundle: nil
        )
        
        //2.
        let identifier = NSStoryboard.SceneIdentifier("ViewController")
        
        //3.
        guard let viewcontroller = storyboard.instantiateController(
            withIdentifier: identifier
        ) as? ViewController else {
            fatalError("Can't find ViewController")
        }
        return viewcontroller
    }
    
}

// MARK: Actions
extension ViewController {
    
    @IBAction func quit(
        _ sender: NSButton
    ) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func reset(
        _ sender: NSButton
    ) {
        
    }
    
}
