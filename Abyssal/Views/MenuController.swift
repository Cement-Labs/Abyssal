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
    
    
    
    @IBOutlet weak var modifierShift: NSBox!
    
    @IBOutlet weak var modifierShiftButton: NSButton!
    
    @IBOutlet weak var modifierOption: NSBox!
    
    @IBOutlet weak var modifierOptionButton: NSButton!
    
    @IBOutlet weak var modifierCommand: NSBox!
    
    @IBOutlet weak var modifierCommandButton: NSButton!
    
    @IBOutlet weak var timeoutLabel: NSTextField!
    
    @IBOutlet weak var timeout: NSSlider!
    

    
    @IBOutlet weak var appTitle: NSTextField!
    
    @IBOutlet weak var appVersion: NSButton!
    
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
        // Init version info
        
        appVersion.title = Helper.versionComponent.version
        
        if Helper.versionComponent.needsUpdate {
            appVersion.isEnabled = true
            appVersion.image = NSImage(systemSymbolName: "shift.fill", accessibilityDescription: nil)
            
            appTitle.textColor = NSColor.controlAccentColor
            appVersion.contentTintColor = NSColor.controlAccentColor
        } else {
            appVersion.isEnabled = false
            appVersion.image = nil
            
            appTitle.textColor = NSColor.labelColor
            appVersion.contentTintColor = NSColor.tertiaryLabelColor
        }
        
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
        
        
        
        modifierShiftButton.flag = Data.modifiers.shift
        modifierOptionButton.flag = Data.modifiers.option
        modifierCommandButton.flag = Data.modifiers.command
        updateModifiers()
        
        timeout.objectValue = Data.timeout
        updateTimeoutEnabled()
        
        startsWithMacOS.flag = Data.startsWithMacos
        
        autoShows.flag = Data.autoShows
        feedbackIntensity.objectValue = Data.feedbackIntensity
        updateFeedbackIntensityEnabled()
        
        useAlwaysHideArea.flag = Data.useAlwaysHideArea
        reduceAnimation.flag = Data.reduceAnimation
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
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            
            updateModifier(modifierShift, Data.modifiers.shift)
            updateModifier(modifierOption, Data.modifiers.option)
            updateModifier(modifierCommand, Data.modifiers.command)
        })
    }
    
    func updateModifier(
        _ box: NSBox,
        _ flag: Bool
    ) {
        let colorOn = Colors.BORDER.withAlphaComponent(0.2)
        let colorOff = Colors.BORDER.withAlphaComponent(0)
        
        box.animator().fillColor = flag ? colorOn : colorOff
    }
    
}

extension MenuController {
    
    func openUrl(
        _ sender: Any?,
        _ url: URL
    ) {
        minimize(sender)
        NSWorkspace.shared.open(url)
    }
    
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
    
    @IBAction func goToRelease(
        _ sender: Any?
    ) {
        openUrl(sender, Helper.RELEASE_URL)
    }
    
    @IBAction func sourceCode(
        _ sender: Any?
    ) {
        openUrl(sender, Helper.SOURCE_CODE_URL)
    }
    
    @IBAction func minimize(
        _ sender: Any?
    ) {
        Helper.delegate?.closePopover(sender)
    }
    
    // MARK: - Data Actions
    @IBAction func toggleModifierShift(
        _ sender: NSButton
    ) {
        Data.modifiers.shift = sender.flag
        updateModifiers()
    }
    
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
