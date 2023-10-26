//
//  Themes.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/18.
//

import Foundation
import AppKit

class Theme: Equatable {
    
    let identifier: String
    
    let name: String
    
    let icon: NSImage
    
    
    
    let headUncollapsed: 	NSImage
    
    let headCollapsed: 		NSImage
    
    let body: 			    NSImage
    
    let tail:				NSImage
    
    
    
    let iconWidth: 		    CGFloat
    
    let iconWidthExpanded:	CGFloat
    
    let autoHideIcons: 	    Bool
    
    init(
        _ identifier: String,
        _ name: String,
        icon: String? = nil, _ iconUseSystemImage: Bool = false,
        
        headUncollapsed: String,
        _ headUncollapsedUseSystemImage: Bool = false,
        _ headUncollapsedSymbolConfiguration: NSImage.SymbolConfiguration? = nil,
        
        headCollapsed: String? = nil,
        _ headCollapsedUseSystemImage: Bool = false,
        _ headCollapsedSymbolConfiguration: NSImage.SymbolConfiguration? = nil,
        
        body: String,
        _ bodyUseSystemImage: Bool = false,
        _ bodySymbolConfiguration: NSImage.SymbolConfiguration? = nil,
        
        tail: String,
        _ tailUseSystemImage: Bool = false,
        _ tailSymbolConfiguration: NSImage.SymbolConfiguration? = nil,
        
        iconWidth:		    CGFloat,
        iconWidthExpanded:  CGFloat,
        autoHideIcons: 	    Bool
    ) {
        let prefix = "Themes/\(identifier)/"
        
        self.identifier = identifier
        self.name = name
        
        self.headUncollapsed = Theme.processImageName(
            prefix,
            headUncollapsed,
            useSystemImage: headUncollapsedUseSystemImage,
            headUncollapsedSymbolConfiguration
        )!
        self.headCollapsed = Theme.processImageName(
            prefix,
            headCollapsed ?? headUncollapsed,
            useSystemImage: headCollapsed != nil ? headCollapsedUseSystemImage : headUncollapsedUseSystemImage,
            headCollapsed != nil ? headCollapsedSymbolConfiguration : headUncollapsedSymbolConfiguration
        )!
        self.body = Theme.processImageName(
            prefix,
            body,
            useSystemImage: bodyUseSystemImage,
            bodySymbolConfiguration
        )!
        self.tail = Theme.processImageName(
            prefix,
            tail,
            useSystemImage: tailUseSystemImage,
            tailSymbolConfiguration
        )!
        
        self.iconWidth 		    = iconWidth
        self.iconWidthExpanded 	= iconWidthExpanded
        self.autoHideIcons 	    = autoHideIcons
        
        self.icon = Theme.processImageName(
            prefix,
            icon ?? headUncollapsed,
            useSystemImage: icon != nil ? iconUseSystemImage : headUncollapsedUseSystemImage
        )!
    }
    
    private static func processImageName(
        _ prefix: String,
        _ name: String?,
        useSystemImage: Bool = false,
        _ symbolConfiguration: NSImage.SymbolConfiguration? = nil
    ) -> NSImage? {
        guard name != nil else { return nil }
        
        if useSystemImage {
            let image = NSImage(systemSymbolName: name!, accessibilityDescription: nil)
            
            if let symbolConfiguration {
                return image?.withSymbolConfiguration(symbolConfiguration)
            } else {
                return image
            }
        }
        
        return NSImage(named: NSImage.Name(prefix + name!))
    }
    
    static func == (
        lhs: Theme,
        rhs: Theme
    ) -> Bool {
        lhs.name == rhs.name
    }
    
}

class Themes {
    
    static var themes: [Theme] {
        [
            abyssal,
            hiddenBar,
            approaching,
            metresAway,
            electrodiagram,
            droplets,
            codec,
            notSoHappy,
            playPause,
            theFace,
            theImplied,
            macOS,
            quoted
        ].sorted(by: { $0.identifier < $1.identifier })
    }
    
    static var defaultTheme: Theme {
        return abyssal
    }
    
    static var themeNames: [String] {
        return themes.map { $0.name }
    }
    
}

extension Themes {
    
    static let abyssal = Theme(
        "Abyssal", NSLocalizedString("Theme/Abyssal", value: "Abyssal", comment: "name for theme 'Abyssal'"),
        icon:               "DottedLine",
        headUncollapsed: 	"Dot",
        body: 			    "Line",
        tail: 				"DottedLine",
        
        iconWidth: 2, iconWidthExpanded: 10,
        autoHideIcons: false
    )
    
    static let hiddenBar = Theme(
        "HiddenBar", NSLocalizedString("Theme/HiddenBar", value: "Hidden Bar", comment: "name for theme 'Hidden Bar'"),
        headUncollapsed: 	"ic_left",
        headCollapsed: 		"ic_right",
        body: 			    "ic_line",
        tail: 				"ic_line_translucent",
        
        iconWidth: 20, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
    static let approaching = Theme(
        "Approaching", NSLocalizedString("Theme/Approaching", value: "Approaching", comment: "name for theme 'Approaching'"),
        headUncollapsed: 	"Primary",
        body: 			    "Secondary",
        tail: 				"Tertiary",
        
        iconWidth: 8, iconWidthExpanded: 16,
        autoHideIcons: true
    )
    
    static let metresAway = Theme(
        "MetresAway", NSLocalizedString("Theme/MetresAway", value: "Metres Away", comment: "name for theme 'Metres Away'"),
        headUncollapsed: 	"Line",
        body: 			    "MetreLine",
        tail: 				"MetreLine",
        
        iconWidth: 3, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
    static let electrodiagram = Theme(
        "Electrodiagram", NSLocalizedString("Theme/Electrodiagram", value: "Electrodiagram", comment: "name for theme 'Electrodiagram'"),
        headUncollapsed: 	"DiagramHead",
        body: 			    "Diagram",
        tail: 				"DiagramTail",
        
        iconWidth: 1, iconWidthExpanded: 18,
        autoHideIcons: false
    )
    
    static let droplets = Theme(
        "Droplets", NSLocalizedString("Theme/Droplets", value: "Droplets", comment: "name for theme 'Droplets'"),
        headUncollapsed: 	"Drops",
        body: 			    "LDrop",
        tail: 				"MDrop",
        
        iconWidth: 6, iconWidthExpanded: 22,
        autoHideIcons: false
    )
    
    static let codec = Theme(
        "Codec", NSLocalizedString("Theme/Codec", value: "Codec", comment: "name for theme 'Codec'"),
        headUncollapsed: 	"curlybraces", true,
        headCollapsed:      "ellipsis.curlybraces", true, .preferringHierarchical(),
        body: 			    "ellipsis", true,
        tail: 				"ellipsis", true,
        
        iconWidth: 16, iconWidthExpanded: 24,
        autoHideIcons: false
    )
    
    static let notSoHappy = Theme(
        "NotSoHappy", NSLocalizedString("Theme/NotSoHappy", value: "Not So Happy", comment: "name for theme 'Not So Happy'"),
        headUncollapsed: 	"Sad",
        headCollapsed: 		"Happy",
        body: 			    "Pale",
        tail: 				"Amazed",
        
        iconWidth: 14, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
    static let playPause = Theme(
        "PlayPause", NSLocalizedString("Theme/PlayPause", value: "Play Pause", comment: "name for theme 'Play Pause'"),
        headUncollapsed:    "play.fill", true,
        headCollapsed:      "pause.fill", true,
        body:               "stop.fill", true,
        tail:               "backward.end.fill", true,
        iconWidth: 22, iconWidthExpanded: 36,
        autoHideIcons: false
    )
    
    static let theFace = Theme(
        "TheFace", NSLocalizedString("Theme/TheFace", value: "【=◈︿◈=】", comment: "name for theme '【=◈︿◈=】'"),
        icon:               "lines.measurement.horizontal", true,
        headUncollapsed:    "Face",
        body:               "lines.measurement.horizontal", true,
        tail:               "lines.measurement.horizontal", true,
        iconWidth: 25, iconWidthExpanded: 64,
        autoHideIcons: false
    )
    
    static let theImplied = Theme(
        "Implication", NSLocalizedString("Theme/Implication", value: "Implication", comment: "name for theme 'Implication'"),
        icon:               "Therefore",
        headUncollapsed:    "Implies",
        body:               "Since",
        tail:               "Therefore",
        iconWidth: 16, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
    static let macOS = Theme(
        "macOS", NSLocalizedString("Theme/MacOS", value: "macOS", comment: "name for theme 'macOS'"),
        icon:               "apple.logo", true,
        headUncollapsed:    "chevron.backward.2", true,
        headCollapsed:      "chevron.forward.2", true,
        body:               "chevron.backward", true,
        tail:               "poweron", true,
        iconWidth: 20, iconWidthExpanded: 20,
        autoHideIcons: false
    )
    
    static let quoted = Theme(
        "macOS", NSLocalizedString("Theme/Quoted", value: "Quoted", comment: "name for theme 'Quoted'"),
        headUncollapsed:    "quote.closing", true,
        body:               "quote.opening", true,
        tail:               "quote.closing", true,
        iconWidth: 16, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
}
