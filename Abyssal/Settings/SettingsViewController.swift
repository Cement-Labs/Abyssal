//
//  SettingsViewController.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/21.
//

import AppKit

class SettingsViewController: NSViewController {
    override func viewWillAppear() {
        VersionHelper.checkNewVersionsTask.resume()
        
        DispatchQueue.main.async {
            AppDelegate.shared?.popover.contentSize = self.view.fittingSize
            AppDelegate.shared?.statusBarController.startFunctionalTimers()
        }
    }
    
    override func viewDidDisappear() {
        DispatchQueue.main.async {
            AppDelegate.shared?.statusBarController.startFunctionalTimers()
        }
    }
}
