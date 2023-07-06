//
//  QuotesViewController.swift
//  BarStalker
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class MenuController: NSViewController, NSMenuDelegate {
    
    var quitAppTrackingArea:    NSTrackingArea?
    
    var linkTrackingArea:       NSTrackingArea?
    
    var minimizeTrackingArea:   NSTrackingArea?
    
    let themesMenu: NSMenu = NSMenu()
    
    // MARK: - Outlets
    
    @IBOutlet var main: NSView!
    
    @IBOutlet weak var layer0__0__1: NSView!
    
    @IBOutlet weak var layer0__1__0: NSBox!
    
    @IBOutlet weak var layer0__1__1: NSBox!
    
    
    
    @IBOutlet weak var layer0__0__0__0: NSBox!
    
    @IBOutlet weak var layer0__0__0__1: NSBox!
    
    @IBOutlet weak var layer0__0__0__2: NSBox!
    
    @IBOutlet weak var quitApp: NSButton!
    
    @IBOutlet weak var link: NSButton!
    
    @IBOutlet weak var minimize: NSButton!
    
    
    
    @IBOutlet weak var quitAppView: NSView!
    
    @IBOutlet weak var linkView: NSView!
    
    @IBOutlet weak var minimizeView: NSView!
    
    @IBOutlet weak var appTitle: NSTextField!
    
    @IBOutlet weak var appVersion: NSTextField!
    
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
        
        if let version = Helper.version {
            appVersion.isHidden = false
            appVersion.stringValue = version
        } else {
            appVersion.isHidden = true
        }
        
        quitAppTrackingArea = NSTrackingArea(
            rect: quitAppView.bounds,
            options: [.activeInActiveApp,
                      .mouseEnteredAndExited],
            owner: self,
            userInfo: ["area": "quitApp"]
        )
        
        linkTrackingArea = NSTrackingArea(
            rect: linkView.bounds,
            options: [.activeInActiveApp,
                      .mouseEnteredAndExited],
            owner: self,
            userInfo: ["area": "link"]
        )
        
        minimizeTrackingArea = NSTrackingArea(
            rect: minimizeView.bounds,
            options: [.activeInActiveApp,
                      .mouseEnteredAndExited],
            owner: self,
            userInfo: ["area": "minimize"]
        )
        
        quitAppView.addTrackingArea(quitAppTrackingArea!)
        linkView.addTrackingArea(linkTrackingArea!)
        minimizeView.addTrackingArea(minimizeTrackingArea!)
    }
    
    override func viewDidAppear() {
        // Helper.CHECK_NEWER_VERSION_TASK.resume()
        Helper.delegate?.statusBarController.startFunctionalTimers()
    }
    
    override func viewWillDisappear() {
        Helper.delegate?.statusBarController.startFunctionalTimers()
    }
    
}

extension MenuController {
    
    // MARK: - Themes Menu Delegate
    
    @objc func menuDidClose(
        _ menu: NSMenu
    ) {
        if
            let menuItem = menu.highlightedItem,
            let index = menu.items.firstIndex(of: menuItem)
        {
            Helper.switchToTheme(index)
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
    
    func blurContents(
        _ value: CGFloat
    ) {
        if value > 0 {
            let blur = CIFilter(name: "CIGaussianBlur")
            blur?.setValue(value, forKey: kCIInputRadiusKey)
            
            appTitle.animator().contentFilters      = [blur!]
            appVersion.animator().contentFilters    = [blur!]
            
            // layer0__0__1.animator().contentFilters  = [blur!]
            layer0__1__0.animator().contentFilters  = [blur!]
            layer0__1__1.animator().contentFilters  = [blur!]
        } else {
            appTitle.animator().contentFilters      = []
            appVersion.animator().contentFilters    = []
            
            // layer0__0__1.animator().contentFilters  = []
            layer0__1__0.animator().contentFilters  = []
            layer0__1__1.animator().contentFilters  = []
        }
    }
    
    func activateQuitApp(
        _ flag: Bool
    ) {
        if flag {
            layer0__0__0__0.animator().borderColor = Colors.DANGER
            layer0__0__0__0.animator().fillColor = Colors.DANGER
            
            quitApp.animator().contentTintColor = NSColor.white
        } else {
            layer0__0__0__0.animator().borderColor = Colors.TRANSLUCENT_DANGER
            layer0__0__0__0.animator().fillColor = Colors.TRANSLUCENT_DANGER
            
            quitApp.animator().contentTintColor = Colors.DANGER
        }
    }
    
    func activateLink(
        _ flag: Bool
    ) {
        if flag {
            layer0__0__0__1.animator().borderColor = Colors.HYPER
            layer0__0__0__1.animator().fillColor = Colors.HYPER
            
            link.animator().contentTintColor = NSColor.white
        } else {
            layer0__0__0__1.animator().borderColor = Colors.TRANSLUCENT_HYPER
            layer0__0__0__1.animator().fillColor = Colors.TRANSLUCENT_HYPER
            
            link.animator().contentTintColor = Colors.HYPER
        }
    }
    
    func activateMinimize(
        _ flag: Bool
    ) {
        if flag {
            layer0__0__0__2.animator().borderColor = Colors.SAFE
            layer0__0__0__2.animator().fillColor = Colors.SAFE
            
            minimize.animator().contentTintColor = NSColor.white
        } else {
            layer0__0__0__2.animator().borderColor = Colors.TRANSLUCENT_SAFE
            layer0__0__0__2.animator().fillColor = Colors.TRANSLUCENT_SAFE
            
            minimize.animator().contentTintColor = Colors.SAFE
        }
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
                
                blurContents(16)
                activateQuitApp(true)
                
            case "link":
                
                blurContents(16)
                activateLink(true)
                
            case "minimize":
                
                blurContents(16)
                activateMinimize(true)
                
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
                
                blurContents(0)
                activateQuitApp(false)
                
            case "link":
                
                blurContents(0)
                activateLink(false)
                
            case "minimize":
                
                blurContents(0)
                activateMinimize(false)
                
            default:
                break
            }
        }
    }
}

extension MenuController {
    
    // MARK: - Global Actions
    
    @IBAction func quit(
        _ sender: Any?
    ) {
        minimize(sender)
        if !(Helper.delegate?.popover.isShown ?? false) {
            NSApplication.shared.terminate(sender)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                NSApplication.shared.terminate(sender)
            }
        }
    }
    
    @IBAction func sourceCode(
        _ sender: Any?
    ) {
        minimize(sender)
        NSWorkspace.shared.open(Helper.SOURCE_CODE_URL)
    }
    
    @IBAction func minimize(
        _ sender: Any?
    ) {
        Helper.delegate?.closePopover(sender)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            Helper.delegate?.statusBarController.triggerFeedback()
        }
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
