//
//  Themes.swift
//  Stalker
//
//  Created by KrLite on 2023/6/18.
//

import Foundation
import AppKit

class Themes {
	
	class Theme: Equatable {
		
		static let EMPTY: NSImage? = NSImage(named: NSImage.Name("Empty"))
		
		
		
		let name: String
		
		
		
		let headUncollapsed: 	NSImage?
		
		let headCollapsed: 		NSImage?
		
		let separator: 			NSImage?
		
		let tail:				NSImage?
		
		
		
		let iconWidth: 		CGFloat
		
		let iconWidthAlt:	CGFloat
		
		let autoHideIcons: 	Bool
		
		init(
			_ name: String,
			
			headUncollapsed: 	String?,
			headCollapsed: 	String?,
			separator: 		String?,
			tail: 			String?,
			
			iconWidth:		CGFloat,
			iconWidthAlt:	CGFloat,
			autoHideIcons: 	Bool
		) {
			self.name = name
			
			self.headUncollapsed 	= headUncollapsed 	!= nil ? NSImage(named: NSImage.Name(headUncollapsed!)) 	: Theme.EMPTY
			self.headCollapsed 		= headCollapsed 	!= nil ? NSImage(named: NSImage.Name(headCollapsed!)) 		: Theme.EMPTY
			self.separator 			= separator 	!= nil ? NSImage(named: NSImage.Name(separator!)) 				: Theme.EMPTY
			self.tail 				= tail 			!= nil ? NSImage(named: NSImage.Name(tail!)) 					: Theme.EMPTY
			
			self.iconWidth 		= iconWidth
			self.iconWidthAlt 	= iconWidthAlt
			self.autoHideIcons 	= autoHideIcons
		}
		
		static func == (
			lhs: Themes.Theme,
			rhs: Themes.Theme
		) -> Bool {
			return lhs.name == rhs.name
		}
		
	}
	
	static var THEMES_LIST: 		[Theme] {
		return [stalker, hiddenBar]
	}
	
	static var THEME_NAMES_LIST: 	[String] {
		return THEMES_LIST.map({ theme in
			return theme.name
		})
	}
	
	static func from(
		_ name: String?
	) -> Theme {
		switch name {
		case stalker.name:
			return stalker
		case hiddenBar.name:
			return hiddenBar
		default:
			return stalker
		}
	}
	
	static let stalker: 	Theme = Theme(
		"Stalker",
		headUncollapsed: 	"Stalker/SepDot",
		headCollapsed: 		nil,
		separator: 			"Stalker/SepLine",
		tail: 				"Stalker/SepDottedLine",
		
		iconWidth: 2, iconWidthAlt: 10,
		autoHideIcons: true
		
	)
	
	static let hiddenBar: 	Theme = Theme(
		"Hidden Bar",
		headUncollapsed: 	"HiddenBar/ic_left",
		headCollapsed: 		"HiddenBar/ic_right",
		separator: 			"HiddenBar/ic_line",
		tail: 				"HiddenBar/ic_line_translucent",
		
		iconWidth: 20, iconWidthAlt: 32,
		autoHideIcons: false
		
	)
	
}
