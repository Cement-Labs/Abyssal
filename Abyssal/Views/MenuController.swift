//
//  MenuController.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa

class MenuController: NSViewController, NSMenuDelegate {
    
    let themesMenu = NSMenu()
    
    let tips = Tips()
    
    // MARK: - Outlets
    
    @IBOutlet var viewMain: NSView!
    
    
    
    @IBOutlet weak var viewModifiers: NSStackView!
    
    @IBOutlet weak var boxModifierControl: NSBox!
    
    @IBOutlet weak var buttonModifierControl: NSButton!
    
    @IBOutlet weak var boxModifierOption: NSBox!
    
    @IBOutlet weak var buttonModifierOption: NSButton!
    
    @IBOutlet weak var boxModifierCommand: NSBox!
    
    @IBOutlet weak var buttonModifierCommand: NSButton!
    
    @IBOutlet weak var labelTimeout: NSTextField!
    
    @IBOutlet weak var sliderTimeout: NSSlider!
    

    
    @IBOutlet weak var labelAppTitle: NSTextField!
    
    @IBOutlet weak var buttonAppVersion: NSButton!
    
    @IBOutlet weak var switchStartsWithMacOS: NSSwitch!
    
    
    
    @IBOutlet weak var boxQuitApp: FillOnHoverBox!
    
    @IBOutlet weak var buttonQuitApp: NSButton!
    
    @IBOutlet weak var boxLink: FillOnHoverBox!
    
    @IBOutlet weak var buttonLink: NSButton!
    
    @IBOutlet weak var boxMinimize: FillOnHoverBox!
    
    @IBOutlet weak var buttonMinimize: NSButton!
    
    @IBOutlet weak var boxTips: FillOnHoverBox!
    
    @IBOutlet weak var buttonTips: NSButton!
    
    
    
    @IBOutlet weak var switchAutoShows: NSSwitch!
    
    @IBOutlet weak var labelFeedbackIntensity: NSTextField!
    
    @IBOutlet weak var sliderFeedbackIntensity: NSSlider!
    
    
    
    @IBOutlet weak var popUpButtonThemes: NSPopUpButton!
    
    @IBOutlet weak var switchUseAlwaysHideArea: NSSwitch!
    
    @IBOutlet weak var switchReduceAnimation: NSSwitch!
    
    // MARK: - Tips
    
    var definedTips: [NSView: (tip: Tip, trackingArea: NSTrackingArea)] = [:]
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initTips()
    }
    
    override func viewDidAppear() {
        Helper.checkNewVersionsTask.resume()
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
        Helper.checkNewVersionsTask.resume()
        
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

extension MenuController {
    
    func initTips() {
        definedTips = [
            buttonAppVersion: (
                tip: Tip(
                    tipString: {
                        !Helper.versionComponent.needsUpdate ? nil : NSLocalizedString("Tip/ButtonAppVersion", value: """
An update is available, click to access the download page.
""", comment: "if (update available) -> (button) app version")
                    }, preferredEdge: .minX
                )!, trackingArea: buttonAppVersion.visibleRect.getTrackingArea(self, viewToAdd: buttonAppVersion)
            ),
            
            viewModifiers: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/ViewModifier/1", value: """
The modifier keys to use. Pressing only one of the chosen keys is enough to trigger the functions. It is recommended to keep the modifier key ⌘ enabled.
""", comment: "(view) modifier")
                    }
                )!, trackingArea: viewModifiers.visibleRect.getTrackingArea(self, viewToAdd: viewModifiers)
            ),
            sliderTimeout: (
                tip: Tip(
                    dataString: { Data.timeoutAttribute.label },
                    tipString: {
                        NSLocalizedString("Tip/SliderTimeout", value: """
Time to countdown before disabling **Auto Idling.**
After interacting with status items that will be automatically hidden, for example, status items inside the **Always Hidden Area,** **Auto Idling** will keep them visible until this timeout is reached or the cursor hovered over the `Hide Separator` or `Always Hide Separator`.
""", comment: "(slider) timeout")
                    }, rect: { self.sliderTimeout.rectOfTickMark(at: self.sliderTimeout.integerValue).offsetBy(dx: 0, dy: 8) }
                )!, trackingArea: sliderTimeout.thumbRect.getTrackingArea(self, viewToAdd: sliderTimeout)
            ),
            switchStartsWithMacOS: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/SwitchStartsWithMacOS", value: """
Run **Abyssal** when macOS starts.
""", comment: "(switch) starts with macOS")
                    }
                )!, trackingArea: switchStartsWithMacOS.visibleRect.getTrackingArea(self, viewToAdd: switchStartsWithMacOS)
            ),
            
            buttonTips: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/ButtonTips", value: """
The tips are currently shown. Click to hide them.
""", comment: "(button) tips")
                    }
                )!, trackingArea: buttonTips.visibleRect.getTrackingArea(self, viewToAdd: buttonTips)
            ),
            buttonLink: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/ButtonLink", value: """
**Abyssal** is open sourced. Click to access the source code repository.
""", comment: "(button) link")
                    }
                )!, trackingArea: buttonLink.visibleRect.getTrackingArea(self, viewToAdd: buttonLink)
            ),
            buttonMinimize: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/ButtonMinimize", value: """
Minimize this window. Right click on the `Menu Separator` to open this window again.
""", comment: "(button) minimize")
                    }, delay: 0.8
                )!, trackingArea: buttonMinimize.visibleRect.getTrackingArea(self, viewToAdd: buttonMinimize)
            ),
            
            popUpButtonThemes: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/PopUpButtonThemes", value: """
Some themes will hide the icons inside the separators automatically, while others not.
Themes that automatically hide the icons will only show them when the status items inside the **Hide Area** are manually set to visible, while other themes indicate this by reducing the separators' opacity.
""", comment: "(pop up button) themes")
                    }, preferredEdge: .minX
                )!, trackingArea: popUpButtonThemes.visibleRect.getTrackingArea(self, viewToAdd: popUpButtonThemes)
            ),
            switchAutoShows: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/SwitchAutoShows", value: """
Auto shows the status items inside the **Hide Area** while the cursor is hovering over the spare area.
If this option is enabled, the status items inside the **Hide Area,** which is between the `Hide Separator` (the middle one) and the `Always Hide Separator` (the trailing one), will be hidden and kept invisible, until the cursor hovers over the spare area, where the status items in **Hide Area** used to stay. Otherwise the status items will be hidden until you switch their visibility state manually.
By left clicking on the `Menu Separator` (the leading one), or clicking using either of the mouse buttons on the other separators, you can manually switch the visibility state of the status items inside the **Hide Area.** If you set them visible, they will never be hidden again until you manually switch their visibility state. Otherwise they will follow the behavior defined above.
""", comment: "(switch) auto shows")
                    }
                )!, trackingArea: switchAutoShows.visibleRect.getTrackingArea(self, viewToAdd: switchAutoShows)
            ),
            sliderFeedbackIntensity: (
                tip: Tip(
                    dataString: {
                        Data.feedbackAttribute.label
                    },
                    tipString: {
                        NSLocalizedString("Tip/SliderFeedbackIntensity", value: """
Feedback intensity given when triggering actions such as 'enabling **Auto Shows**' or 'canceling **Auto Idling**'.
""", comment: "(slider) feedback intensity")
                    }, rect: { self.sliderFeedbackIntensity.rectOfTickMark(at: self.sliderFeedbackIntensity.integerValue).offsetBy(dx: 0, dy: 8) }
                )!, trackingArea: sliderFeedbackIntensity.thumbRect.getTrackingArea(self, viewToAdd: sliderFeedbackIntensity)
            ),
            
            switchUseAlwaysHideArea: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/SwitchUseAlwaysHideArea", value: """
Hide certain status items permanently by moving them left of the `Always Hide Separator` to the **Always Hide Area.**
The status items inside the **Always Hide Area** will be hidden and invisible until the cursor hovers over the spare area with a modifier key down, or while this window is opened.
""", comment: "(switch) use always hide area")
                    }
                )!, trackingArea: switchUseAlwaysHideArea.visibleRect.getTrackingArea(self, viewToAdd: switchUseAlwaysHideArea)
            ),
            switchReduceAnimation: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/SwitchReduceAnimations", value: """
Reduce animations to gain a more performant experience.
""", comment: "(switch) reduce animations")
                    }
                )!, trackingArea: switchReduceAnimation.visibleRect.getTrackingArea(self, viewToAdd: switchReduceAnimation)
            )
        ]
        
        definedTips.forEach { tips.bind($0.key, trackingArea: $0.value.trackingArea, tip: $0.value.tip) }
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
        
        buttonAppVersion.title = Helper.versionComponent.version
        
        if Helper.versionComponent.needsUpdate {
            buttonAppVersion.isEnabled = true
            buttonAppVersion.image = NSImage(systemSymbolName: "shift.fill", accessibilityDescription: nil)
        } else {
            buttonAppVersion.isEnabled = false
            buttonAppVersion.image = nil
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
                
                themesMenu.addItem(item)
            }
            
            popUpButtonThemes.removeAllItems()
            popUpButtonThemes.menu = themesMenu
            popUpButtonThemes.menu?.delegate = self
            
            if let index = Themes.themes.firstIndex(of: Data.theme) {
                popUpButtonThemes.selectItem(at: index)
            }
        }
        
        // Controls
        
        sliderTimeout.minValue = 0
        sliderTimeout.maxValue = Double(Data.timeoutTickMarks - 1)
        sliderTimeout.numberOfTickMarks = Data.timeoutTickMarks
        
        sliderFeedbackIntensity.minValue = 0
        sliderFeedbackIntensity.maxValue = Double(Data.feedbackIntensityTickMarks - 1)
        sliderFeedbackIntensity.numberOfTickMarks = Data.feedbackIntensityTickMarks
        
        
        
        buttonModifierControl.flag = Data.modifiers.control
        buttonModifierOption.flag = Data.modifiers.option
        buttonModifierCommand.flag = Data.modifiers.command
        
        sliderTimeout.objectValue = Data.timeout
        updateTimeoutEnabled()
        
        switchStartsWithMacOS.flag = Data.startsWithMacos
        buttonTips.flag = Data.tips
        
        switchAutoShows.flag = Data.autoShows
        sliderFeedbackIntensity.objectValue = Data.feedbackIntensity
        updateFeedbackIntensityEnabled()
        
        switchUseAlwaysHideArea.flag = Data.useAlwaysHideArea
        switchReduceAnimation.flag = Data.reduceAnimation
        
        updateColoredWidgets()
    }
    
    func updateColoredWidgets() {
        if Helper.versionComponent.needsUpdate {
            buttonAppVersion.contentTintColor = Colors.Opaque.accent
        } else {
            buttonAppVersion.contentTintColor = NSColor.tertiaryLabelColor
        }
        
        updateColoredModifiers()
        updateColoredButtons()
    }
    
    func updateColoredModifiers() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.1
            
            updateColoredModifier(boxModifierControl, Data.modifiers.control)
            updateColoredModifier(boxModifierOption, Data.modifiers.option)
            updateColoredModifier(boxModifierCommand, Data.modifiers.command)
        })
    }
    
    private func updateColoredModifier(
        _ box: NSBox,
        _ flag: Bool
    ) {
        let colorOn = NSColor.quaternaryLabelColor.withAlphaComponent(0.07)
        let colorOff = NSColor.quaternaryLabelColor.withAlphaComponent(0)
        
        box.animator().fillColor = flag ? colorOn : colorOff
    }
    
    func updateColoredButtons() {
        boxQuitApp.setOriginlalFillColor(Colors.Translucent.danger)
        boxQuitApp.animator().borderColor = Colors.Translucent.danger
        buttonQuitApp.animator().contentTintColor = Colors.Opaque.danger
        
        boxTips.setOriginlalFillColor(Colors.Translucent.accent)
        boxTips.overrideFillColor(Data.tips ? Colors.Opaque.accent : nil)
        boxTips.animator().borderColor = Colors.Translucent.accent
        buttonTips.animator().contentTintColor = Data.tips ? NSColor.white : Colors.Opaque.accent
        buttonTips.image = Data.tips
        ? NSImage(systemSymbolName: "tag.fill", accessibilityDescription: nil)
        : NSImage(systemSymbolName: "tag.slash", accessibilityDescription: nil)
        
        boxLink.setOriginlalFillColor(Colors.Translucent.accent)
        boxLink.animator().borderColor = Colors.Translucent.accent
        buttonLink.animator().contentTintColor = Colors.Opaque.accent
        
        boxMinimize.setOriginlalFillColor(Colors.Translucent.safe)
        boxMinimize.animator().borderColor = Colors.Translucent.safe
        buttonMinimize.animator().contentTintColor = Colors.Opaque.safe
    }
    
}

extension MenuController {
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        tips.mouseEntered(with: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        tips.mouseExited(with: event)
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
        setSliderLabelEnabled(labelTimeout, Data.timeoutAttribute.attr != nil)
        
        definedTips[sliderTimeout]?.tip.update()
    }
    
    func updateFeedbackIntensityEnabled() {
        setSliderEnabled(sliderFeedbackIntensity, Data.autoShows)
        setSliderLabelEnabled(labelFeedbackIntensity, Data.autoShows && Data.feedbackIntensity != 0)
        
        definedTips[sliderFeedbackIntensity]?.tip.update()
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
        openUrl(sender, Helper.urlRelease)
    }
    
    @IBAction func sourceCode(
        _ sender: Any?
    ) {
        openUrl(sender, Helper.urlSourceCode)
    }
    
    @IBAction func minimize(
        _ sender: Any?
    ) {
        if (
            definedTips.values
                .filter { $0.tip.isShown }
                .count > 0
        ) {
            // Containing nested popover(s).
            definedTips.values
                .map { $0.tip }
                .filter { $0.isShown }
                .forEach { $0.close() }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                Helper.delegate?.closePopover(sender)
            }
        } else {
            // Containing none nested popover.
            Helper.delegate?.closePopover(sender)
        }
    }
    
    // MARK: - Data Actions
    @IBAction func toggleModifierControl(
        _ sender: NSButton
    ) {
        Data.modifiers.control = sender.flag
        updateColoredModifiers()
    }
    
    @IBAction func toggleModifierOption(
        _ sender: NSButton
    ) {
        Data.modifiers.option = sender.flag
        updateColoredModifiers()
    }
    
    @IBAction func toggleModifierCommand(
        _ sender: NSButton
    ) {
        Data.modifiers.command = sender.flag
        updateColoredModifiers()
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
        updateColoredButtons()
        
        if sender.flag {
            definedTips[buttonTips]?.tip.show(buttonTips)
        } else {
            definedTips[buttonTips]?.tip.close()
        }
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
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now()) {
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
