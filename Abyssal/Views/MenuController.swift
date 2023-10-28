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
    
    var themeIndexKey = UnsafeRawPointer(bitPattern: "themeIndexKey".hashValue)
    
    private static var menuAppearanceObservation: NSKeyValueObservation?
    
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
    
    @IBOutlet weak var sliderDeadZone: NSSlider!
    
    @IBOutlet weak var viewDeadZone: NSStackView!
    
    
    
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
    
    override func viewWillAppear() {
        VersionHelper.checkNewVersionsTask.resume()
        AppDelegate.instance?.statusBarController.startFunctionalTimers()
        
        updateSliderDeadZone()
    }
    
    override func viewDidDisappear() {
        AppDelegate.instance?.statusBarController.startFunctionalTimers()
    }
    
}

extension MenuController {
    
    // MARK: - Storyboard Instantiation
    
    static func freshController() -> MenuController {
        VersionHelper.checkNewVersionsTask.resume()
        
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
    
    func updateColoredWidgets() {
        if VersionHelper.versionComponent.needsUpdate {
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
    
    func updateSliderTimeout() {
        setSliderLabelEnabled(labelTimeout, Data.timeoutAttribute.attr != nil)
        
        definedTips[sliderTimeout]?.tip.update()
    }
    
    func updateSliderFeedbackIntensity() {
        setSliderEnabled(sliderFeedbackIntensity, Data.autoShows)
        setSliderLabelEnabled(labelFeedbackIntensity, Data.autoShows && Data.feedbackIntensity != 0)
        
        definedTips[sliderFeedbackIntensity]?.tip.update()
    }
    
    func updateSliderDeadZone() {
        viewDeadZone.isHidden = !ScreenHelper.hasNotch
        
        definedTips[sliderDeadZone]?.tip.update()
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
        
        if !(AppDelegate.instance?.popover.isShown ?? false) {
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
                AppDelegate.instance?.closePopover(sender)
            }
        } else {
            // Containing none nested popover.
            AppDelegate.instance?.closePopover(sender)
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
        updateSliderTimeout()
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
        updateSliderFeedbackIntensity()
    }
    
    @IBAction func toggleFeedbackIntensity(
        _ sender: NSSlider
    ) {
        Data.feedbackIntensity = sender.integerValue
        updateSliderFeedbackIntensity()
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now()) {
            AppDelegate.instance?.statusBarController.triggerFeedback()
        }
    }
    
    @IBAction func toggleDeadZone(
        _ sender: NSSlider
    ) {
        Data.deadZone = CGFloat(sender.floatValue)
        updateSliderDeadZone()
    }
    
    
    
    @IBAction func toggleUseAlwaysHideArea(
        _ sender: NSSwitch
    ) {
        Data.useAlwaysHideArea = sender.flag
        AppDelegate.instance?.statusBarController.untilTailVisible(sender.flag)
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
