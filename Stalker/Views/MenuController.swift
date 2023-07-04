//
//  QuotesViewController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class MenuController: NSViewController, NSMenuDelegate {
    
    var quitAppTrackingArea: NSTrackingArea?
    
    var stalkerTrackingArea: NSTrackingArea?
    
    let themesMenu: NSMenu = NSMenu()
    
    // MARK: - Outlets
    
    @IBOutlet var main: NSView!
    
    @IBOutlet weak var appTitle: NSTextField!
    
    @IBOutlet weak var startsWithMacos: NSSwitch!
    
    
    
    @IBOutlet weak var autoShows: NSSwitch!
    
    @IBOutlet weak var feedbackIntensityLabel: NSTextField!
    
    @IBOutlet weak var feedbackIntensity: NSSlider!
    
    
    
    @IBOutlet weak var themes: NSPopUpButton!
    
    @IBOutlet weak var useAlwaysHideArea:   NSSwitch!
    
    @IBOutlet weak var reduceAnimation:     NSSwitch!
    
    // MARK: - View Methods
    
    override func viewDidLoad(
    ) {
        super.viewDidLoad()
        updateData()
    }
    
    override func viewDidAppear() {
        Helper.CHECK_NEWER_VERSION_TASK.resume()
        Helper.delegate?.statusBarController.startFunctionalTimers()
    }
    
    override func viewWillDisappear() {
        Helper.delegate?.statusBarController.startFunctionalTimers()
    }
    
}

extension MenuController {
    
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

extension MenuController {
    
    // MARK: - Storyboard Instantiation
    
    static func freshController() -> MenuController {
        let storyboard = NSStoryboard(
            name: NSStoryboard.Name("Main"),
            bundle: nil
        )
        
        let identifier = NSStoryboard.SceneIdentifier("MenuController")
        
        guard let controller = storyboard.instantiateController(
            withIdentifier: identifier
        ) as? MenuController else {
            fatalError("Can not find MenuController")
        }
        
        return controller
    }
    
}

extension MenuController {
    
    func updateData() {
        // Init themes menu
        
        do {
            themes.removeAllItems()
            themes.addItems(withTitles: Themes.themeNames)
            themes.menu?.delegate = self
            
            if let index = Themes.themes.firstIndex(of: Data.theme) {
                themes.selectItem(at: index)
            }
            
            /* Deprecated
             
            var maxWidth: CGFloat = 0
            if let menu = themes.menu {
                for item in menu.items {
                    let size = NSAttributedString(string: item.title).size()
                    maxWidth = max(maxWidth, size.width)
                }
                
                themes.widthAnchor.constraint(equalToConstant: maxWidth + 65).isActive = true
            }
             
             */
        }
        
        // Init controls
        
        startsWithMacos.set(Data.startsWithMacos)
        
        autoShows.set(Data.autoShows)
        feedbackIntensity.objectValue = Data.feedbackIntensity
        feedBackIntensityEnabled(Data.autoShows)
        
        useAlwaysHideArea.set(Data.useAlwaysHideArea)
        reduceAnimation.set(Data.reduceAnimation)
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

extension MenuController {
    
    // MARK: - Tracking Areas
    
    override func mouseEntered(
        with event: NSEvent
    ) {
        super.mouseEntered(with: event)
        
        if let userInfo = event.trackingArea?.userInfo as? [String : String], let area = userInfo["area"] {
            switch area {
            case "quitApp":
                
                break
                
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
                
                break
                
            default:
                break
            }
        }
    }
}

extension MenuController {
    
    // MARK: - Global Actions
    
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
