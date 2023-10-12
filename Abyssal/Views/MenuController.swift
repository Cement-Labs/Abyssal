//
//  QuotesViewController.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class MenuController: NSViewController, NSMenuDelegate {
    
    let themesMenu: NSMenu = NSMenu()
    
    // MARK: - Outlets
    
    @IBOutlet var main: NSView!
    
    
    
    @IBOutlet weak var quitAppView: NSView!
    
    @IBOutlet weak var linkView: NSView!
    
    @IBOutlet weak var minimizeView: NSView!
    
    
    
    @IBOutlet weak var modifierOption: NSBox!
    
    @IBOutlet weak var modifierCommand: NSBox!
    
    @IBOutlet weak var timeoutLabel: NSTextField!
    
    @IBOutlet weak var timeout: NSSlider!
    

    
    @IBOutlet weak var appTitle: NSTextField!
    
    @IBOutlet weak var appVersion: NSTextField!
    
    @IBOutlet weak var startsWithMacOS: NSSwitch!
    
    
    
    @IBOutlet weak var autoShows: NSSwitch!
    
    @IBOutlet weak var feedbackIntensityLabel: NSTextField!
    
    @IBOutlet weak var feedbackIntensity: NSSlider!
    
    
    
    @IBOutlet weak var themes: NSPopUpButton!
    
    @IBOutlet weak var useAlwaysHideArea: NSSwitch!
    
    @IBOutlet weak var reduceAnimation: NSSwitch!
    
    // MARK: - View Methods
    
    override func viewDidLoad(
    ) {
        super.viewDidLoad()
        initData()
        
        if let version = Helper.version {
            appVersion.isHidden = false
            appVersion.stringValue = version
        } else {
            appVersion.isHidden = true
        }
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

var indexKey = UnsafeRawPointer(bitPattern: "indexKey".hashValue)

extension MenuController {
    
    @objc func switchToTheme(
        _ sender: Any
    ) {
        if
            let button = sender as? NSMenuItem,
            let index = objc_getAssociatedObject(button, &indexKey) as? Int
        {
            Helper.switchToTheme(index)
        }
    }
    
    func initData() {
        // Init themes menu
        
        do {
            for (index, theme) in Themes.themes.enumerated() {
                let item: NSMenuItem = NSMenuItem(
                    title: Themes.themeNames[index],
                    action: #selector(self.switchToTheme(_:)),
                    keyEquivalent: ""
                )
                
                item.image = theme.icon
                objc_setAssociatedObject(item, &indexKey, index, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                self.themesMenu.addItem(item)
            }
            
            self.themes.removeAllItems()
            self.themes.menu = self.themesMenu
            self.themes.menu?.delegate = self
            
            if let index = Themes.themes.firstIndex(of: Data.theme) {
                self.themes.selectItem(at: index)
            }
        }
        
        // Init controls
        
        timeout.minValue = 0
        timeout.maxValue = Double(Data.timeoutTickMarks - 1)
        timeout.numberOfTickMarks = Data.timeoutTickMarks
        
        feedbackIntensity.minValue = 0
        feedbackIntensity.maxValue = Double(Data.feedbackIntensityTickMarks - 1)
        feedbackIntensity.numberOfTickMarks = Data.feedbackIntensityTickMarks
        
        
        
        updateModifiers()
        
        timeout.objectValue = Data.timeout
        updateTimeoutEnabled()
        
        startsWithMacOS.set(Data.startsWithMacos)
        
        autoShows.set(Data.autoShows)
        feedbackIntensity.objectValue = Data.feedbackIntensity
        updateFeedbackIntensityEnabled()
        
        useAlwaysHideArea.set(Data.useAlwaysHideArea)
        reduceAnimation.set(Data.reduceAnimation)
    }
    
    
    
    func setSliderEnabled(
        _ slider: NSSlider,
        _ flag: Bool
    ) {
        slider.isEnabled = flag
    }
    
    func setSliderLabelEnabled(
        _ label: NSTextField,
        _ flag: Bool
    ) {
        label.textColor = flag ? NSColor.labelColor : NSColor.disabledControlTextColor
    }
    
    func updateTimeoutEnabled() {
        setSliderEnabled(timeout, Data.autoShows)
        setSliderLabelEnabled(timeoutLabel, Data.timeoutAttribute.attr != nil)
    }
    
    func updateFeedbackIntensityEnabled() {
        setSliderEnabled(feedbackIntensity, Data.autoShows)
        setSliderLabelEnabled(feedbackIntensityLabel, Data.feedbackIntensity != 0)
    }
    
    
    
    func updateModifiers() {
        modifierOption.fillColor = Data.modifiers.option ? NSColor.quinaryLabel : NSColor.clear
        modifierCommand.fillColor = Data.modifiers.command ? NSColor.quinaryLabel : NSColor.clear
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
    @IBAction func toggleModifierOption(
        _ sender: NSButton
    ) {
        Data.modifiers.option = sender.flag
        updateModifiers()
    }
    
    @IBAction func toggleModifierCommand(
        _ sender: NSButton
    ) {
        Data.modifiers.command = sender.flag
        updateModifiers()
    }
    
    
    
    @IBAction func toggleAutoShows(
        _ sender: NSSwitch
    ) {
        Data.autoShows = sender.flag
        updateFeedbackIntensityEnabled()
    }
    
    @IBAction func toggleFeedbackIntensity(
        _ sender: NSSlider
    ) {
        Data.feedbackIntensity = sender.integerValue
        updateFeedbackIntensityEnabled()
        
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
