//
//  MenuController+Tips.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/28.
//

import Foundation
import AppKit

extension MenuController {
    
    // MARK: - Data
    
    func initData() {
        // Version info
        
        buttonAppVersion.title = VersionHelper.versionComponent.version
        
        if VersionHelper.versionComponent.needsUpdate {
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
        sliderTimeout.allowsTickMarkValuesOnly = true
        
        sliderFeedbackIntensity.minValue = 0
        sliderFeedbackIntensity.maxValue = Double(Data.feedbackIntensityTickMarks - 1)
        sliderFeedbackIntensity.numberOfTickMarks = Data.feedbackIntensityTickMarks
        sliderFeedbackIntensity.allowsTickMarkValuesOnly = true
        
        sliderDeadZone.minValue = 0
        sliderDeadZone.maxValue = Data.deadZoneMaxValue
        sliderDeadZone.numberOfTickMarks = 0
        sliderDeadZone.allowsTickMarkValuesOnly = false
        
        
        
        buttonModifierControl.flag = Data.modifiers.control
        buttonModifierOption.flag = Data.modifiers.option
        buttonModifierCommand.flag = Data.modifiers.command
        
        sliderTimeout.objectValue = Data.timeout
        updateSliderTimeout()
        
        switchStartsWithMacOS.flag = Data.startsWithMacos
        buttonTips.flag = Data.tips
        
        switchAutoShows.flag = Data.autoShows
        sliderFeedbackIntensity.objectValue = Data.feedbackIntensity
        sliderDeadZone.objectValue = Data.deadZone
        updateSliderFeedbackIntensity()
        updateSliderDeadZone()
        
        switchUseAlwaysHideArea.flag = Data.useAlwaysHideArea
        switchReduceAnimation.flag = Data.reduceAnimation
        
        updateColoredWidgets()
    }
    
}

extension MenuController {
    
    // MARK: - Tips
    
    func initTips() {
        definedTips = [
            buttonAppVersion: (
                tip: Tip(
                    tipString: {
                        !VersionHelper.versionComponent.needsUpdate ? nil : NSLocalizedString("Tip/ButtonAppVersion", value: """
An update is available, click to access the download page.
""", comment: "if (update available) -> (button) app version")
                    }, preferredEdge: .minX
                )!, trackingArea: buttonAppVersion.visibleRect.getTrackingArea(self, viewToAdd: buttonAppVersion)
            ),
            
            viewModifiers: (
                tip: Tip(
                    tipString: {
                        NSLocalizedString("Tip/ViewModifier", value: """
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
                    },
                    rect: { self.sliderTimeout.knobRect },
                    offset: { NSPoint(x: 0, y: 8) }
                )!, trackingArea: sliderTimeout.knobRect.getTrackingArea(self, viewToAdd: sliderTimeout)
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
If this option is enabled, the status items inside the **Hide Area,** which is between the `Hide Separator` (the middle one) and the `Always Hide Separator` (the farthest one to the screen corner), will be hidden and kept invisible, until the cursor hovers over the spare area, where the status items in **Hide Area** used to stay. Otherwise the status items will be hidden until you switch their visibility state manually.
By left clicking on the `Menu Separator` (the nearest one to the screen corner), or clicking using either of the mouse buttons on the other separators, you can manually switch the visibility state of the status items inside the **Hide Area.** If you set them visible, they will never be hidden again until you manually switch their visibility state. Otherwise they will follow the behavior defined above.
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
                    },
                    rect: { self.sliderFeedbackIntensity.knobRect },
                    offset: { NSPoint(x: 0, y: 8) }
                )!, trackingArea: sliderFeedbackIntensity.knobRect.getTrackingArea(self, viewToAdd: sliderFeedbackIntensity)
            ),
            sliderDeadZone: (
                tip: Tip(
                    dataString: {
                        Data.deadZonePercentage
                    },
                    tipString: {
                        NSLocalizedString("Tip/SliderDeadZone", value: """
The ignored status bar width on screens without notches, in percentage.
Due to the limitations of macOS, **Abyssal** can't infer the available width used for collapsing. Therefore, you may need to toggle it manually in order to acquire a better experience. On screens with notches, the ignored width is set to about 55% of the screen width.
""", comment: "(slider) dead zone")
                    },
                    rect: { self.sliderDeadZone.knobRect },
                    offset: { NSPoint(x: 0, y: 8) }
                )!, trackingArea: sliderDeadZone.knobRect.getTrackingArea(self, viewToAdd: sliderDeadZone)
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
