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
            
            headUncollapsed: 	String,
            headCollapsed: 		String? = nil,
            separator: 			String,
            tail: 				String,
            
            iconWidth:		CGFloat,
            iconWidthAlt:	CGFloat,
            autoHideIcons: 	Bool
        ) {
            let prefix = "Themes/\(identifier)/"
            
            self.name = name
            self.identifier = identifier
            
            self.headUncollapsed 	= NSImage(named: NSImage.Name(prefix + headUncollapsed))!
            self.headCollapsed 		= NSImage(named: NSImage.Name(prefix + (headCollapsed ?? headUncollapsed)))!
            self.separator 			= NSImage(named: NSImage.Name(prefix + separator))!
            self.tail 				= NSImage(named: NSImage.Name(prefix + tail))!
            
            self.iconWidth 		= iconWidth
            self.iconWidthAlt 	= iconWidthAlt
            self.autoHideIcons 	= autoHideIcons
            
            self.icon = NSImage(named: NSImage.Name(prefix + (icon ?? headUncollapsed)))!
        }
        
        static func == (
            lhs: Themes.Theme,
            rhs: Themes.Theme
        ) -> Bool {
            lhs.name == rhs.name
        }
        
    }
    
}

extension Themes {
    
    static var themes: [Theme] {
        [
            abyssal,
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
        return abyssal
    }
    
    static var themeNames: [String] {
        return themes.map { $0.name }
    }
    
}

extension Themes {
    
    static let abyssal: Theme = Theme(
        String(
            localized: 	"Abyssal",
            comment: 	"Name for theme 'Abyssal'"
        ), "Abyssal", "DottedLine",
        headUncollapsed: 	"Dot",
        separator: 			"Line",
        tail: 				"DottedLine",
        
        iconWidth: 2, iconWidthAlt: 10,
        autoHideIcons: true
    )
    
    static let hiddenBar: Theme = Theme(
        String(
            localized: 	"Hidden Bar",
            comment: 	"Name for theme 'Hidden Bar'"
        ), "HiddenBar",
        headUncollapsed: 	"ic_left",
        headCollapsed: 		"ic_right",
        separator: 			"ic_line",
        tail: 				"ic_line_translucent",
        
        iconWidth: 20, iconWidthAlt: 32,
        autoHideIcons: false
    )
    
    static let approaching: Theme = Theme(
        String(
            localized: 	"Approaching",
            comment: 	"Name for theme 'Approaching'"
        ), "Approaching",
        headUncollapsed: 	"Primary",
        headCollapsed: 		"Primary",
        separator: 			"Secondary",
        tail: 				"Tertiary",
        
        iconWidth: 8, iconWidthAlt: 16,
        autoHideIcons: true
    )
    
    static let metresAway: Theme = Theme(
        String(
            localized: 	"Metres Away",
            comment: 	"Name for theme 'Metres Away'"
        ), "MetresAway",
        headUncollapsed: 	"Line",
        separator: 			"MetreLine",
        tail: 				"MetreLine",
        
        iconWidth: 3, iconWidthAlt: 32,
        autoHideIcons: false
    )
    
    static let electrodiagram: Theme = Theme(
        String(
            localized: 	"Electrodiagram",
            comment: 	"Name for theme 'Electrodiagram'"
        ), "Electrodiagram",
        headUncollapsed: 	"DiagramHead",
        headCollapsed: 		"DiagramHead",
        separator: 			"Diagram",
        tail: 				"DiagramTail",
        
        iconWidth: 1, iconWidthAlt: 18,
        autoHideIcons: false
    )
    
    static let droplets: Theme = Theme(
        String(
            localized: 	"Droplets",
            comment: 	"Name for theme 'Droplets'"
        ), "Droplets",
        headUncollapsed: 	"Drops",
        headCollapsed: 		"Drops",
        separator: 			"LDrop",
        tail: 				"MDrop",
        
        iconWidth: 6, iconWidthAlt: 22,
        autoHideIcons: false
    )
    
    static let codec: Theme = Theme(
        String(
            localized: 	"Codec",
            comment: 	"Name for theme 'Codec'"
        ), "Codec",
        headUncollapsed: 	"R",
        headCollapsed: 		"R",
        separator: 			"L",
        tail: 				"P",
        
        iconWidth: 16, iconWidthAlt: 24,
        autoHideIcons: false
    )
    
    static let notSoHappy: Theme = Theme(
        String(
            localized: 	"Not So Happy",
            comment: 	"Name for theme 'Not So Happy'"
        ), "NotSoHappy",
        headUncollapsed: 	"Sad",
        headCollapsed: 		"Happy",
        separator: 			"Pale",
        tail: 				"Amazed",
        
        iconWidth: 14, iconWidthAlt: 32,
        autoHideIcons: false
    )
    
}
