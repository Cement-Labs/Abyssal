//
//  Theme.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/18.
//

import Foundation
import AppKit
import Defaults

enum SelectFromExistingIconBuilder {
    case headUncollapsed
    case headCollapsed
    case body
    case tail
    case custom(any IconBuilder)
}

enum SelectFromHeadUncollapsedIconBuilder {
    case head
    case headWithWidth(CGFloat)
    case custom(any IconBuilder)
}

class Theme: Equatable {
    let identifier: String
    let name: String
    let icon: Icon
    
    let headUncollapsed: Icon
    let headCollapsed: Icon
    let body: Icon
    let tail: Icon
    
    let autoHideIcons: Bool
    
    init(
        _ identifier: String,
        _ name: String,
        icon: SelectFromExistingIconBuilder? = nil,
        
        headUncollapsed: any IconBuilder,
        headCollapsed: SelectFromHeadUncollapsedIconBuilder? = nil,
        body: any IconBuilder,
        tail: any IconBuilder,
        
        autoHideIcons: Bool
    ) {
        self.identifier = identifier
        self.name = name
        
        self.headUncollapsed = headUncollapsed.build(identifier: identifier)
        self.headCollapsed = switch headCollapsed ?? .head {
        case .head: self.headUncollapsed
        case .headWithWidth(let width): headUncollapsed.build(identifier: identifier, width: width)
        case .custom(let iconBuilder): iconBuilder.build(identifier: identifier)
        }
        self.body = body.build(identifier: identifier)
        self.tail = tail.build(identifier: identifier)
        
        self.autoHideIcons 	    = autoHideIcons
        
        self.icon = switch icon ?? .headUncollapsed {
        case .headUncollapsed: self.headUncollapsed
        case .headCollapsed: self.headCollapsed
        case .body: self.body
        case .tail: self.tail
        case .custom(let iconBuilder): iconBuilder.build(identifier: identifier)
        }
    }
    
    static func == (
        lhs: Theme,
        rhs: Theme
    ) -> Bool {
        lhs.identifier == rhs.identifier
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
    
    static var themeIdentifiers: [String] {
        return themes.map { $0.identifier }
    }
    
    static var themeNames: [String] {
        return themes.map { $0.name }
    }
}

extension Themes {
    static let abyssal = Theme(
        "Abyssal", NSLocalizedString("Theme/Abyssal", value: "Abyssal", comment: "name for theme 'Abyssal'"),
        icon: .tail,
        
        headUncollapsed: 	NamedIconBuilder(name: "Dot", width: 10),
        headCollapsed:      .headWithWidth(2),
        
        body: NamedIconBuilder(name: "Line",          width: 2),
        tail: NamedIconBuilder(name: "DottedLine",    width: 2),
        
        autoHideIcons: false
    )
    
    static let hiddenBar = Theme(
        "HiddenBar", NSLocalizedString("Theme/HiddenBar", value: "Hidden Bar", comment: "name for theme 'Hidden Bar'"),
        
        headUncollapsed: 	NamedIconBuilder(name:"ic_left", width: 20),
        headCollapsed: 		.custom(NamedIconBuilder(name:"ic_right", width: 20)),
        
        body: NamedIconBuilder(name:"ic_line",                width: 20),
        tail: NamedIconBuilder(name:"ic_line_translucent",    width: 20),
        
        autoHideIcons: false
    )
    
    static let approaching = Theme(
        "Approaching", NSLocalizedString("Theme/Approaching", value: "Approaching", comment: "name for theme 'Approaching'"),
        
        headUncollapsed: 	NamedIconBuilder(name: "Primary", width: 8),
        headCollapsed:      .headWithWidth(16),
        
        body: NamedIconBuilder(name: "Secondary", width: 8),
        tail: NamedIconBuilder(name: "Tertiary",  width: 8),
        
        autoHideIcons: true
    )
    
    static let metresAway = Theme(
        "MetresAway", NSLocalizedString("Theme/MetresAway", value: "Metres Away", comment: "name for theme 'Metres Away'"),
        
        headUncollapsed: 	NamedIconBuilder(name: "Line", width: 3),
        headCollapsed:      .headWithWidth(32),
        
        body: NamedIconBuilder(name: "MetreLine", width: 3),
        tail: NamedIconBuilder(name: "MetreLine", width: 3),
        
        autoHideIcons: false
    )
    
    static let electrodiagram = Theme(
        "Electrodiagram", NSLocalizedString("Theme/Electrodiagram", value: "Electrodiagram", comment: "name for theme 'Electrodiagram'"),
        
        headUncollapsed: 	NamedIconBuilder(name: "DiagramHead", width: 1),
        headCollapsed:      .headWithWidth(18),
        
        body: NamedIconBuilder(name: "Diagram",       width: 1),
        tail: NamedIconBuilder(name: "DiagramTail",   width: 1),
        
        autoHideIcons: false
    )
    
    static let droplets = Theme(
        "Droplets", NSLocalizedString("Theme/Droplets", value: "Droplets", comment: "name for theme 'Droplets'"),
        
        headUncollapsed: 	NamedIconBuilder(name: "Drops", width: 6),
        headCollapsed:      .headWithWidth(32),
        
        body: NamedIconBuilder(name: "LDrop", width: 6),
        tail: NamedIconBuilder(name: "MDrop", width: 6),
        
        autoHideIcons: false
    )
    
    static let codec = Theme(
        "Codec", NSLocalizedString("Theme/Codec", value: "Codec", comment: "name for theme 'Codec'"),
        
        headUncollapsed: 	SymbolIconBuilder(symbol: .curlybraces, width: 16),
        headCollapsed:      .custom(SymbolIconBuilder(symbol: .ellipsisCurlybraces, configuration: .preferringHierarchical(), width: 22)),
        
        body: SymbolIconBuilder(symbol: .ellipsis, width: 16, opacity: 0.5),
        tail: SymbolIconBuilder(symbol: .ellipsis, width: 16, opacity: 0.2),
        
        autoHideIcons: false
    )
    
    static let notSoHappy = Theme(
        "NotSoHappy", NSLocalizedString("Theme/NotSoHappy", value: "Not So Happy", comment: "name for theme 'Not So Happy'"),
        
        headUncollapsed: 	NamedIconBuilder(name: "Sad", width: 14),
        headCollapsed: 		.custom(NamedIconBuilder(name: "Happy", width: 32)),
        
        body: NamedIconBuilder(name: "Pale",   width: 14),
        tail: NamedIconBuilder(name: "Amazed", width: 14),
        
        autoHideIcons: false
    )
    
    static let playPause = Theme(
        "PlayPause", NSLocalizedString("Theme/PlayPause", value: "Play Pause", comment: "name for theme 'Play Pause'"),
        
        headUncollapsed:    SymbolIconBuilder(symbol: .playFill, width: 22),
        headCollapsed:      .custom(SymbolIconBuilder(symbol: .pauseFill, width: 36)),
        
        body: SymbolIconBuilder(symbol: .forwardEndFill,    width: 22, opacity: 0.2),
        tail: SymbolIconBuilder(symbol: .backwardEndFill,   width: 22, opacity: 0.2),
        
        autoHideIcons: true
    )
    
    static let theFace = Theme(
        "TheFace", NSLocalizedString("Theme/TheFace", value: "【=◈︿◈=】", comment: "name for theme '【=◈︿◈=】'"),
        icon: .tail,
        
        headUncollapsed:    NamedIconBuilder(name: "Face", width: 25),
        headCollapsed:      .headWithWidth(64),
        
        body: SymbolIconBuilder(symbol: .musicNote,         width: 16, opacity: 0.5),
        tail: SymbolIconBuilder(symbol: .musicQuarternote3, width: 16, opacity: 0.2),
        
        autoHideIcons: false
    )
    
    static let theImplied = Theme(
        "Implication", NSLocalizedString("Theme/Implication", value: "Implication", comment: "name for theme 'Implication'"),
        icon: .tail,
        
        headUncollapsed:    NamedIconBuilder(name: "Implies", width: 16),
        headCollapsed:      .headWithWidth(32),
        
        body: NamedIconBuilder(name: "Since",     width: 16),
        tail: NamedIconBuilder(name: "Therefore", width: 16),
        
        autoHideIcons: false
    )
    
    static let macOS = Theme(
        "macOS", NSLocalizedString("Theme/MacOS", value: "macOS", comment: "name for theme 'macOS'"),
        icon: .custom(SymbolIconBuilder(symbol: .appleLogo, width: 20)),
        
        headUncollapsed:    SymbolIconBuilder(symbol: .chevronBackward, width: 20),
        
        body: SymbolIconBuilder(symbol: .poweron, width: 20, opacity: 0.5),
        tail: SymbolIconBuilder(symbol: .poweron, width: 20, opacity: 0.2),
        
        autoHideIcons: true
    )
}
