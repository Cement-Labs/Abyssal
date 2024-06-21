//
//  SettingsViewController.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/21.
//

import AppKit

class SettingsViewController: NSViewController {
    override func viewWillAppear() {
        print(AppDelegate.instance?.popover.contentSize, view.fittingSize)
        AppDelegate.instance?.popover.contentSize = view.fittingSize
        VersionHelper.checkNewVersionsTask.resume()
        AppDelegate.instance?.statusBarController.startFunctionalTimers()
    }
    
    override func viewDidDisappear() {
        AppDelegate.instance?.statusBarController.startFunctionalTimers()
    }
}
