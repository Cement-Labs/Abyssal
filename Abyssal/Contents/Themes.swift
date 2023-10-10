//
//  Themes.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/18.
//

import Foundation
import AppKit

class Themes {
    
    class Theme: Equatable {
        
        static let EMPTY: NSImage = NSImage(named: NSImage.Name("Themes/Empty"))!
        
        
        
        let name: String
        
        let identifier: String
        
        let icon: NSImage
        
        
        
        let headUncollapsed: 	NSImage
        
        let headCollapsed: 		NSImage
        
        let separator: 			NSImage
        
        let tail:				NSImage
        
        
        
        let iconWidth: 		CGFloat
        
        let iconWidthAlt:	CGFloat
        
        let autoHideIcons: 	Bool
        
        init(
            _ name: String,
            _ identifier: String,
            _ icon: String? = nil,
            
            headUncollapsed: 	String?,
            headCollapsed: 		String?,
            separator: 			String?,
            tail: 				String?,
            
            iconWidth:		CGFloat,
            iconWidthAlt:	CGFloat,
            autoHideIcons: 	Bool
        ) {
            self.name = name
            self.identifier = identifier
            
            self.headUncollapsed 	= (headUncollapsed  != nil ? NSImage(named: NSImage.Name(headUncollapsed!)) : Theme.EMPTY) ?? Theme.EMPTY
            self.headCollapsed 		= (headCollapsed    != nil ? NSImage(named: NSImage.Name(headCollapsed!))   : Theme.EMPTY) ?? Theme.EMPTY
            self.separator 			= (separator        != nil ? NSImage(named: NSImage.Name(separator!))       : Theme.EMPTY) ?? Theme.EMPTY
            self.tail 				= (tail             != nil ? NSImage(named: NSImage.Name(tail!))            : Theme.EMPTY) ?? Theme.EMPTY
            
            self.iconWidth 		= iconWidth
            self.iconWidthAlt 	= iconWidthAlt
            self.autoHideIcons 	= autoHideIcons
            
            self.icon = (icon != nil ? NSImage(named: NSImage.Name(icon!)) : self.headUncollapsed) ?? Theme.EMPTY
        }
        
        static func == (
            lhs: Themes.Theme,
            rhs: Themes.Theme
        ) -> Bool {
            return lhs.name == rhs.name
        }
        
    }
    
    static var themes: [Theme] {
        return [
            stalker,
            hiddenBar,
            approaching,
            metresAway,
            electrodiagram,
            droplets,
            codec,
            notSoHappy
        ].sorted(by: { $0.identifier < $1.identifier })
    }
    
    static var defaultTheme: Theme {
        return stalker
    }
    
    static var themeNames: [String] {
        return themes.map { $0.name }
    }
    
    static let stalker: Theme = Theme(
        String(
            localized: 	"Abyssal",
            comment: 	"Name for theme 'Abyssal'"
        ), "abyssal", "Themes/Abyssal/DottedLine",
        headUncollapsed: 	"Themes/Abyssal/Dot",
        headCollapsed: 		"Themes/Abyssal/Dot",
        separator: 			"Themes/Abyssal/Line",
        tail: 				"Themes/Abyssal/DottedLine",
        
        iconWidth: 2, iconWidthAlt: 10,
        autoHideIcons: true
    )
    
    static let hiddenBar: Theme = Theme(
        String(
            localized: 	"Hidden Bar",
            comment: 	"Name for theme 'Hidden Bar'"
        ), "hiddenBar",
        headUncollapsed: 	"Themes/HiddenBar/ic_left",
        headCollapsed: 		"Themes/HiddenBar/ic_right",
        separator: 			"Themes/HiddenBar/ic_line",
        tail: 				"Themes/HiddenBar/ic_line_translucent",
        
        iconWidth: 20, iconWidthAlt: 32,
        autoHideIcons: false
    )
    
    static let approaching: Theme = Theme(
        String(
            localized: 	"Approaching",
            comment: 	"Name for theme 'Approaching'"
        ), "approaching",
        headUncollapsed: 	"Themes/Approaching/Primary",
        headCollapsed: 		"Themes/Approaching/Primary",
        separator: 			"Themes/Approaching/Secondary",
        tail: 				"Themes/Approaching/Tertiary",
        
        iconWidth: 8, iconWidthAlt: 16,
        autoHideIcons: true
    )
    
    static let metresAway: Theme = Theme(
        String(
            localized: 	"Metres Away",
            comment: 	"Name for theme 'Metres Away'"
        ), "metresAway",
        headUncollapsed: 	"Themes/MetresAway/Line",
        headCollapsed: 		"Themes/MetresAway/Line",
        separator: 			"Themes/MetresAway/MetreLine",
        tail: 				"Themes/MetresAway/MetreLine",
        
        iconWidth: 3, iconWidthAlt: 32,
        autoHideIcons: false
    )
    
    static let electrodiagram: Theme = Theme(
        String(
            localized: 	"Electrodiagram",
            comment: 	"Name for theme 'Electrodiagram'"
        ), "electrodiagram",
        headUncollapsed: 	"Themes/Electrodiagram/DiagramHead",
        headCollapsed: 		"Themes/Electrodiagram/DiagramHead",
        separator: 			"Themes/Electrodiagram/Diagram",
        tail: 				"Themes/Electrodiagram/DiagramTail",
        
        iconWidth: 1, iconWidthAlt: 18,
        autoHideIcons: false
    )
    
    static let droplets: Theme = Theme(
        String(
            localized: 	"Droplets",
            comment: 	"Name for theme 'Droplets'"
        ), "droplets",
        headUncollapsed: 	"Themes/Droplets/Drops",
        headCollapsed: 		"Themes/Droplets/Drops",
        separator: 			"Themes/Droplets/LDrop",
        tail: 				"Themes/Droplets/MDrop",
        
        iconWidth: 6, iconWidthAlt: 22,
        autoHideIcons: false
    )
    
    static let codec: Theme = Theme(
        String(
            localized: 	"Codec",
            comment: 	"Name for theme 'Codec'"
        ), "codec",
        headUncollapsed: 	"Themes/Codec/R",
        headCollapsed: 		"Themes/Codec/R",
        separator: 			"Themes/Codec/L",
        tail: 				"Themes/Codec/P",
        
        iconWidth: 16, iconWidthAlt: 24,
        autoHideIcons: false
    )
    
    static let notSoHappy: Theme = Theme(
        String(
            localized: 	"Not So Happy",
            comment: 	"Name for theme 'Not So Happy'"
        ), "notSoHappy",
        headUncollapsed: 	"Themes/NotSoHappy/Sad",
        headCollapsed: 		"Themes/NotSoHappy/Happy",
        separator: 			"Themes/NotSoHappy/Pale",
        tail: 				"Themes/NotSoHappy/Amazed",
        
        iconWidth: 14, iconWidthAlt: 32,
        autoHideIcons: false
    )
    
}
