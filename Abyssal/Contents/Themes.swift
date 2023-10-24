//
//  Themes.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/18.
//

import Foundation
import AppKit

class Theme: Equatable {
    
    let name: String
    
    let identifier: String
    
    let icon: NSImage
    
    
    
    let headUncollapsed: 	NSImage
    
    let headCollapsed: 		NSImage
    
    let body: 			    NSImage
    
    let tail:				NSImage
    
    
    
    let iconWidth: 		    CGFloat
    
    let iconWidthExpanded:	CGFloat
    
    let autoHideIcons: 	    Bool
    
    init(
        _ name: String,
        _ identifier: String,
        icon: String? = nil, _ iconUseSystemImage: Bool = false,
        
        headUncollapsed: 	String,         _ headUncollapsedUseSystemImage: Bool = false,
        headCollapsed: 		String? = nil,  _ headCollapsedUseSystemImage: Bool = false,
        body: 			    String,         _ bodyUseSystemImage: Bool = false,
        tail: 				String,         _ tailUseSystemImage: Bool = false,
        
        iconWidth:		    CGFloat,
        iconWidthExpanded:  CGFloat,
        autoHideIcons: 	    Bool
    ) {
        let prefix = "Themes/\(identifier)/"
        
        self.name = name
        self.identifier = identifier
        
        self.headUncollapsed 	= Theme.processImageName(prefix, headUncollapsed, useSystemImage: headUncollapsedUseSystemImage)!
        self.headCollapsed 		= Theme.processImageName(
            prefix,
            headCollapsed ?? headUncollapsed,
            useSystemImage: headCollapsed != nil ? headCollapsedUseSystemImage : headUncollapsedUseSystemImage
        )!
        self.body 			    = Theme.processImageName(prefix, body, useSystemImage: bodyUseSystemImage)!
        self.tail 				= Theme.processImageName(prefix, tail, useSystemImage: tailUseSystemImage)!
        
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
        useSystemImage: Bool = false
    ) -> NSImage? {
        guard name != nil else { return nil }
        
        if useSystemImage {
            return NSImage(systemSymbolName: name!, accessibilityDescription: nil)
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
            macOS
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
        String(
            localized: 	"Abyssal",
            comment: 	"name for theme 'Abyssal'"
        ), "Abyssal", icon: "DottedLine",
        headUncollapsed: 	"Dot",
        body: 			    "Line",
        tail: 				"DottedLine",
        
        iconWidth: 2, iconWidthExpanded: 10,
        autoHideIcons: false
    )
    
    static let hiddenBar = Theme(
        String(
            localized: 	"Hidden Bar",
            comment: 	"name for theme 'HiddenBar'"
        ), "HiddenBar",
        headUncollapsed: 	"ic_left",
        headCollapsed: 		"ic_right",
        body: 			    "ic_line",
        tail: 				"ic_line_translucent",
        
        iconWidth: 20, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
    static let approaching = Theme(
        String(
            localized: 	"Approaching",
            comment: 	"name for theme 'Approaching'"
        ), "Approaching",
        headUncollapsed: 	"Primary",
        body: 			    "Secondary",
        tail: 				"Tertiary",
        
        iconWidth: 8, iconWidthExpanded: 16,
        autoHideIcons: true
    )
    
    static let metresAway = Theme(
        String(
            localized: 	"Metres Away",
            comment: 	"name for theme 'MetresAway'"
        ), "MetresAway",
        headUncollapsed: 	"Line",
        body: 			    "MetreLine",
        tail: 				"MetreLine",
        
        iconWidth: 3, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
    static let electrodiagram = Theme(
        String(
            localized: 	"Electrodiagram",
            comment: 	"name for theme 'Electrodiagram'"
        ), "Electrodiagram",
        headUncollapsed: 	"DiagramHead",
        body: 			    "Diagram",
        tail: 				"DiagramTail",
        
        iconWidth: 1, iconWidthExpanded: 18,
        autoHideIcons: false
    )
    
    static let droplets = Theme(
        String(
            localized: 	"Droplets",
            comment: 	"name for theme 'Droplets'"
        ), "Droplets",
        headUncollapsed: 	"Drops",
        body: 			    "LDrop",
        tail: 				"MDrop",
        
        iconWidth: 6, iconWidthExpanded: 22,
        autoHideIcons: false
    )
    
    static let codec = Theme(
        String(
            localized: 	"Codec",
            comment: 	"name for theme 'Codec'"
        ), "Codec",
        headUncollapsed: 	"curlybraces", true,
        headCollapsed:      "ellipsis.curlybraces", true,
        body: 			    "sum", true,
        tail: 				"plus", true,
        
        iconWidth: 12, iconWidthExpanded: 24,
        autoHideIcons: false
    )
    
    static let notSoHappy = Theme(
        String(
            localized: 	"Not So Happy",
            comment: 	"name for theme 'NotSoHappy'"
        ), "NotSoHappy",
        headUncollapsed: 	"Sad",
        headCollapsed: 		"Happy",
        body: 			    "Pale",
        tail: 				"Amazed",
        
        iconWidth: 14, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
    static let playPause = Theme(
        String(
            localized:  "Play Pause",
            comment:    "name for theme 'PlayPause'"
        ), "PlayPause",
        headUncollapsed:    "play.fill", true,
        headCollapsed:      "pause.fill", true,
        body:               "stop.fill", true,
        tail:               "backward.end.fill", true,
        iconWidth: 22, iconWidthExpanded: 36,
        autoHideIcons: false
    )
    
    static let theFace = Theme(
        String(
            localized:  "【=◈︿◈=】",
            comment:    "name for theme 'TheFace'"
        ), "TheFace", icon: "lines.measurement.horizontal", true,
        headUncollapsed:    "Face",
        body:               "lines.measurement.horizontal", true,
        tail:               "lines.measurement.horizontal", true,
        iconWidth: 25, iconWidthExpanded: 64,
        autoHideIcons: false
    )
    
    static let theImplied = Theme(
        String(
            localized:  "The Implied",
            comment:    "name for theme 'TheImplied'"
        ), "TheImplied", icon: "Therefore",
        headUncollapsed:    "Implies",
        body:               "Since",
        tail:               "Therefore",
        iconWidth: 16, iconWidthExpanded: 32,
        autoHideIcons: false
    )
    
    static let macOS = Theme(
        String(
            localized:  "macOS",
            comment:    "name for theme 'macOS'"
        ), "macOS", icon: "apple.logo", true,
        headUncollapsed:    "chevron.compact.left", true,
        headCollapsed:      "chevron.compact.right", true,
        body:               "chevron.backward.2", true,
        tail:               "chevron.backward.2", true,
        iconWidth: 12, iconWidthExpanded: 20,
        autoHideIcons: false
    )
    
}
