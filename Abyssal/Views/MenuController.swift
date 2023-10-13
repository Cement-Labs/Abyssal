//
//  MenuController.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class MenuController: NSViewController, NSMenuDelegate {
    
    let themesMenu: NSMenu = NSMenu()
    
    // MARK: - Outlets
    
    @IBOutlet var main: NSView!
    
    
    
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
    
    
    
    @IBOutlet weak var quitApp: FillOnHoverBox!
    
    @IBOutlet weak var quitAppButton: NSButton!
    
    @IBOutlet weak var link: FillOnHoverBox!
    
    @IBOutlet weak var linkButton: NSButton!
    
    @IBOutlet weak var minimize: FillOnHoverBox!
    
    @IBOutlet weak var minimizeButton: NSButton!
    
    @IBOutlet weak var tips: FillOnHoverBox!
    
    @IBOutlet weak var tipsButton: NSButton!
    
    
    
    @IBOutlet weak var autoShows: NSSwitch!
    
    @IBOutlet weak var feedbackIntensityLabel: NSTextField!
    
    @IBOutlet weak var feedbackIntensity: NSSlider!
    
    
    
    @IBOutlet weak var themes: NSPopUpButton!
    
    @IBOutlet weak var useAlwaysHideArea: NSSwitch!
    
    @IBOutlet weak var reduceAnimation: NSSwitch!
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
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

var menuAppearanceObservation: NSKeyValueObservation?

extension MenuController {
    
    // MARK: - Storyboard Instantiation
    
    static func freshController() -> MenuController {
        Helper.CHECK_NEWER_VERSION_TASK.resume()
        
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
        
        // Observe appearance change
        menuAppearanceObservation = NSApp.observe(\.effectiveAppearance) { (app, _) in
            app.effectiveAppearance.performAsCurrentDrawingAppearance {
                let menuController = ((app.delegate as? AppDelegate)?.popover.contentViewController as? MenuController)
                
                if menuController?.isViewLoaded ?? false {
                    menuController?.updateColoredWidgets()
                }
            }
        }
        
        return controller
    }
    
}

var themeIndexKey = UnsafeRawPointer(bitPattern: "themeIndexKey".hashValue)

extension MenuController {
    
    @objc func switchToTheme(
        _ sender: Any
    ) {
        if
            let button = sender as? NSMenuItem,
            let index = objc_getAssociatedObject(button, &themeIndexKey) as? Int
        {
            Helper.switchToTheme(index)
        }
    }
    
    func initData() {
        // Version info
        
        appVersion.title = Helper.versionComponent.version
        
        if Helper.versionComponent.needsUpdate {
            appVersion.isEnabled = true
            appVersion.image = NSImage(systemSymbolName: "shift.fill", accessibilityDescription: nil)
        } else {
            appVersion.isEnabled = false
            appVersion.image = nil
        }
        
        // Themes menu
        
        do {
            for (index, theme) in Themes.themes.enumerated() {
                let item: NSMenuItem = NSMenuItem(
                    title: Themes.themeNames[index],
                    action: #selector(self.switchToTheme(_:)),
                    keyEquivalent: ""
                )
                
                item.image = theme.icon
                objc_setAssociatedObject(item, &themeIndexKey, index, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                self.themesMenu.addItem(item)
            }
            
            self.themes.removeAllItems()
            self.themes.menu = self.themesMenu
            self.themes.menu?.delegate = self
            
            if let index = Themes.themes.firstIndex(of: Data.theme) {
                self.themes.selectItem(at: index)
            }
        }
        
        // Controls
        
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
        
        updateColoredWidgets()
    }
    
    func updateColoredWidgets() {
        if Helper.versionComponent.needsUpdate {
            appVersion.contentTintColor = Colors.Opaque.accent
        } else {
            appVersion.contentTintColor = NSColor.tertiaryLabelColor
        }
        
        updateModifiers()
        updateButtons()
    }
    
    func updateModifiers() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            
            updateModifier(modifierShift, Data.modifiers.shift)
            updateModifier(modifierOption, Data.modifiers.option)
            updateModifier(modifierCommand, Data.modifiers.command)
        })
    }
    
    private func updateModifier(
        _ box: NSBox,
        _ flag: Bool
    ) {
        let colorOn = NSColor.quaternaryLabelColor.withAlphaComponent(0.07)
        let colorOff = NSColor.quaternaryLabelColor.withAlphaComponent(0)
        
        box.animator().fillColor = flag ? colorOn : colorOff
    }
    
    func updateButtons() {
        quitApp.setOriginlalFillColor(Colors.Translucent.DANGER)
        quitApp.animator().borderColor = Colors.Translucent.DANGER
        quitAppButton.animator().contentTintColor = Colors.Opaque.DANGER
        
        tips.setOriginlalFillColor(Colors.Translucent.accent)
        tips.overrideFillColor(Data.tips ? Colors.Opaque.accent : nil)
        tips.animator().borderColor = Colors.Translucent.accent
        tipsButton.animator().contentTintColor = Data.tips ? NSColor.labelColor : Colors.Opaque.accent
        tipsButton.image = Data.tips
        ? NSImage(systemSymbolName: "tag.fill", accessibilityDescription: nil)
        : NSImage(systemSymbolName: "tag.slash", accessibilityDescription: nil)
        
        link.setOriginlalFillColor(Colors.Translucent.accent)
        link.animator().borderColor = Colors.Translucent.accent
        linkButton.animator().contentTintColor = Colors.Opaque.accent
        
        minimize.setOriginlalFillColor(Colors.Translucent.SAFE)
        minimize.animator().borderColor = Colors.Translucent.SAFE
        minimizeButton.animator().contentTintColor = Colors.Opaque.SAFE
    }
    
}

extension MenuController {
    
    private func setSliderEnabled(
        _ slider: NSSlider,
        _ flag: Bool
    ) {
        slider.isEnabled = flag
    }
    
    private func setSliderLabelEnabled(
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
        setSliderLabelEnabled(feedbackIntensityLabel, Data.autoShows && Data.feedbackIntensity != 0)
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
    
    @IBAction func toggleTimeout(
        _ sender: NSSlider
    ) {
        Data.timeout = sender.integerValue
        updateTimeoutEnabled()
    }
    
    @IBAction func toggleTips(
        _ sender: NSButton
    ) {
        Data.tips = sender.flag
        updateButtons()
        showTest(at: timeout.thumbRect)
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
