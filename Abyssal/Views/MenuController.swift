//
//  MenuController.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import Cocoa
import Defaults

class MenuController: NSViewController, NSMenuDelegate {
    
    let themesMenu = NSMenu()
    
    let tips = Tips()
    
    private static var menuAppearanceObservation: NSKeyValueObservation?
    
    // MARK: - Outlets
    
    @IBOutlet var viewMain: NSView!
    
    
    
    @IBOutlet weak var viewModifiers: NSStackView!
    
    @IBOutlet weak var boxModifiersControl: FillOnHoverBox!
    
    @IBOutlet weak var buttonModifiersControl: NSButton!
    
    @IBOutlet weak var boxModifiersOption: FillOnHoverBox!
    
    @IBOutlet weak var buttonModifiersOption: NSButton!
    
    @IBOutlet weak var boxModifiersCommand: FillOnHoverBox!
    
    @IBOutlet weak var buttonModifiersCommand: NSButton!
    
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
        updateColors()
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
                    menuController?.updateColors()
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
            let index = themesMenu.items.firstIndex(of: button)
        {
            Helper.switchToTheme(index)
        }
    }
    
    func updateColors() {
        buttonQuitApp.animator().contentTintColor = Colors.Opaque.danger
        
        buttonMinimize.animator().contentTintColor = Colors.Opaque.safe
        
        updateColoredVersionInfo()
        updateColoredModifiers()
        updateColoredButtons()
    }
    
    func updateColoredVersionInfo() {
        if VersionHelper.versionComponent.needsUpdate {
            buttonAppVersion.contentTintColor = Colors.Opaque.accent
        } else {
            buttonAppVersion.contentTintColor = NSColor.tertiaryLabelColor
        }
    }
    
    func updateColoredModifiers() {
        boxModifiersControl.setHoverColor(Colors.Translucent.accent)
        boxModifiersControl.setBorderHoverColor(Colors.Opaque.accent)
        
        boxModifiersControl.setFallbackColor(Colors.thinBackgroundColor)
        boxModifiersControl.setBorderFallbackColor(Colors.thinBackgroundColor)
        
        boxModifiersOption.setHoverColor(Colors.Translucent.accent)
        boxModifiersOption.setBorderHoverColor(Colors.Opaque.accent)
        
        boxModifiersOption.setFallbackColor(Colors.thinBackgroundColor)
        boxModifiersOption.setBorderFallbackColor(Colors.thinBackgroundColor)
        
        boxModifiersCommand.setHoverColor(Colors.Translucent.accent)
        boxModifiersCommand.setBorderHoverColor(Colors.Opaque.accent)
        
        boxModifiersCommand.setFallbackColor(Colors.thinBackgroundColor)
        boxModifiersCommand.setBorderFallbackColor(Colors.thinBackgroundColor)
        
        let modifiers = Defaults[.modifiers]
        
        boxModifiersControl.setOverrideColor(modifiers.control ? Colors.Opaque.accent : nil)
        boxModifiersControl.setBorderOverrideColor(modifiers.control ? Colors.thinBackgroundColor : nil)
        
        buttonModifiersControl.animator().contentTintColor = Colors.isDarkMode || !modifiers.control ? .labelColor : .controlColor
        
        boxModifiersOption.setOverrideColor(modifiers.option ? Colors.Opaque.accent : nil)
        boxModifiersOption.setBorderOverrideColor(modifiers.option ? Colors.thinBackgroundColor : nil)
        
        buttonModifiersOption.animator().contentTintColor = Colors.isDarkMode || !modifiers.option ? .labelColor : .controlColor
        
        boxModifiersCommand.setOverrideColor(modifiers.command ? Colors.Opaque.accent : nil)
        boxModifiersCommand.setBorderOverrideColor(modifiers.command ? Colors.thinBackgroundColor : nil)
        
        
        buttonModifiersCommand.animator().contentTintColor = Colors.isDarkMode || !modifiers.command ? .labelColor : .controlColor
    }
    
    func updateColoredButtons() {
        boxQuitApp.setHoverColor(Colors.Translucent.danger)
        boxQuitApp.setBorderHoverColor(Colors.Opaque.danger)
        
        boxQuitApp.setFallbackColor(Colors.thinBackgroundColor)
        boxQuitApp.setBorderFallbackColor(Colors.thinBackgroundColor)
        
        boxTips.setHoverColor(Colors.Translucent.accent)
        boxTips.setBorderHoverColor(Colors.Opaque.accent)
        
        boxTips.setFallbackColor(Colors.thinBackgroundColor)
        boxTips.setBorderFallbackColor(Colors.thinBackgroundColor)
        
        boxLink.setHoverColor(Colors.Translucent.accent)
        boxLink.setBorderHoverColor(Colors.Opaque.accent)
        
        boxLink.setFallbackColor(Colors.thinBackgroundColor)
        boxLink.setBorderFallbackColor(Colors.thinBackgroundColor)
        
        boxMinimize.setHoverColor(Colors.Translucent.safe)
        boxMinimize.setBorderHoverColor(Colors.Opaque.safe)
        
        boxMinimize.setFallbackColor(Colors.thinBackgroundColor)
        boxMinimize.setBorderFallbackColor(Colors.thinBackgroundColor)
        
        let tipsEnabled = Defaults[.tipsEnabled]
        
        boxTips.setOverrideColor(tipsEnabled ? Colors.Opaque.accent : nil)
        boxTips.setBorderOverrideColor(tipsEnabled ? Colors.thinBackgroundColor : nil)
        
        buttonTips.image = tipsEnabled
        ? NSImage(systemSymbolName: "tag.fill", accessibilityDescription: nil)
        : NSImage(systemSymbolName: "tag.slash", accessibilityDescription: nil)
        buttonTips.animator().contentTintColor = Colors.isDarkMode || !tipsEnabled ? .labelColor : .controlColor
    }
    
    func minimizeAndDo(
        _ sender: Any?, execute: @escaping () -> Void
    ) {
        minimize(sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: execute)
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
        setSliderLabelEnabled(labelTimeout, Defaults[.timeout].attribute != nil)
        
        let _ = definedTips[sliderTimeout]?.tip.update()
    }
    
    func updateSliderFeedbackIntensity() {
        setSliderEnabled(sliderFeedbackIntensity, Defaults[.autoShowsEnabled])
        setSliderLabelEnabled(labelFeedbackIntensity, Defaults[.autoShowsEnabled] && Defaults[.feedback] != .none)
        
        let _ = definedTips[sliderFeedbackIntensity]?.tip.update()
    }
    
    func updateSliderDeadZone() {
        viewDeadZone.isHidden = ScreenHelper.hasNotch
        
        let _ = definedTips[sliderDeadZone]?.tip.update()
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
    
    @IBAction func quitApp(
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
        minimizeAndDo(sender) {
            self.openUrl(sender, Helper.urlRelease)
        }
    }
    
    @IBAction func sourceCode(
        _ sender: Any?
    ) {
        minimizeAndDo(sender) {
            self.openUrl(sender, Helper.urlSourceCode)
        }
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
    @IBAction func toggleModifiersControl(
        _ sender: NSButton
    ) {
        Defaults[.modifiers].control = sender.flag
        updateColoredModifiers()
    }
    
    @IBAction func toggleModifiersOption(
        _ sender: NSButton
    ) {
        Defaults[.modifiers].option = sender.flag
        updateColoredModifiers()
    }
    
    @IBAction func toggleModifiersCommand(
        _ sender: NSButton
    ) {
        Defaults[.modifiers].command = sender.flag
        updateColoredModifiers()
    }
    
    @IBAction func toggleTimeout(
        _ sender: NSSlider
    ) {
        Defaults[.timeout] = TimeoutAttribute.allCases[sender.integerValue]
        updateSliderTimeout()
    }
    
    @IBAction func toggleTips(
        _ sender: NSButton
    ) {
        Defaults[.tipsEnabled] = sender.flag
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
        Defaults[.autoShowsEnabled] = sender.flag
        updateSliderFeedbackIntensity()
    }
    
    @IBAction func toggleFeedbackIntensity(
        _ sender: NSSlider
    ) {
        Defaults[.feedback] = FeedbackAttribute.allCases[sender.integerValue]
        updateSliderFeedbackIntensity()
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now()) {
            AppDelegate.instance?.statusBarController.triggerFeedback()
        }
    }
    
    @IBAction func toggleDeadZone(
        _ sender: NSSlider
    ) {
        Defaults[.deadZone].percentage = CGFloat(sender.floatValue)
        updateSliderDeadZone()
    }
    
    
    
    @IBAction func toggleUseAlwaysHideArea(
        _ sender: NSSwitch
    ) {
        Defaults[.alwaysHideAreaEnabled] = sender.flag
        AppDelegate.instance?.statusBarController.untilTailVisible(sender.flag)
    }
    
    @IBAction func toggleReduceAnimation(
        _ sender: NSSwitch
    ) {
        Defaults[.reduceAnimationEnabled] = sender.flag
    }
    
    
    
    @IBAction func toggleStartsWithMacos(
        _ sender: NSSwitch
    ) {
        Defaults[.launchAtLogin] = sender.flag
    }
    
}
