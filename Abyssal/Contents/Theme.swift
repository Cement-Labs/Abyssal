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
    case headInactive
    case headActive
    case body
    case tail
    case custom(any IconBuilder)
}

enum SelectFromHeadUncollapsedIconBuilder {
    case head
    case headWithWidth(CGFloat)
    case custom(any IconBuilder)
}

class Theme: Equatable, Identifiable {
    let id: String
    let name: String
    let icon: Icon

    let headInactive: Icon
    let headActive: Icon
    let body: Icon
    let tail: Icon

    let autoHidesIcons: Bool

    init(
        _ identifier: String,
        _ name: String,
        icon: SelectFromExistingIconBuilder? = nil,

        headInactive: any IconBuilder,
        headActive: SelectFromHeadUncollapsedIconBuilder? = nil,
        body: any IconBuilder,
        tail: any IconBuilder,

        autoHideIcons: Bool
    ) {
        self.id = identifier
        self.name = name

        self.headInactive = headInactive.build(identifier: identifier)

        self.headActive = switch headActive ?? .head {
        case .head: self.headInactive
        case .headWithWidth(let width): headInactive.build(identifier: identifier, width: width)
        case .custom(let iconBuilder): iconBuilder.build(identifier: identifier)
        }

        self.body = body.build(identifier: identifier)
        self.tail = tail.build(identifier: identifier)

        self.autoHidesIcons = autoHideIcons

        self.icon = switch icon ?? .headInactive {
        case .headInactive: self.headInactive
        case .headActive: self.headActive
        case .body: self.body
        case .tail: self.tail
        case .custom(let iconBuilder): iconBuilder.build(identifier: identifier)
        }
    }

    static func == (
        lhs: Theme,
        rhs: Theme
    ) -> Bool {
        lhs.id == rhs.id
    }
}

extension Theme {
    static let abyssal = Theme(
        "Abyssal", .init(localized: "Abyssal"),
        icon: .tail,

        headInactive: NamedIconBuilder(name: "Dot", width: 2),
        headActive: .headWithWidth(10),

        body: NamedIconBuilder(name: "Line", width: 2),
        tail: NamedIconBuilder(name: "DottedLine", width: 2),

        autoHideIcons: false
    )

    static let hiddenBar = Theme(
        "HiddenBar", .init(localized: "Hidden Bar"),

        headInactive: NamedIconBuilder(name: "ic_left", width: 20),
        headActive: .custom(NamedIconBuilder(name: "ic_right", width: 20)),

        body: NamedIconBuilder(name: "ic_line", width: 20),
        tail: NamedIconBuilder(name: "ic_line_translucent", width: 20),

        autoHideIcons: false
    )

    static let simplicity = Theme(
        "Simplicity", .init(localized: "Simplicity"),

        headInactive: SymbolIconBuilder(symbol: .poweron, width: 4),
        headActive: .custom(SymbolIconBuilder(symbol: .poweron, width: 12, opacity: 0.2)),

        body: SymbolIconBuilder(symbol: .poweron, width: 2),
        tail: SymbolIconBuilder(symbol: .poweron, width: 2),

        autoHideIcons: true
    )

    static let approaching = Theme(
        "Approaching", .init(localized: "Approaching"),

        headInactive: NamedIconBuilder(name: "Primary", width: 8),
        headActive: .headWithWidth(16),

        body: NamedIconBuilder(name: "Secondary", width: 8),
        tail: NamedIconBuilder(name: "Tertiary", width: 8),

        autoHideIcons: true
    )

    static let metresAway = Theme(
        "MetresAway", .init(localized: "Metres Away"),

        headInactive: NamedIconBuilder(name: "Line", width: 3),
        headActive: .headWithWidth(32),

        body: NamedIconBuilder(name: "MetreLine", width: 3),
        tail: NamedIconBuilder(name: "MetreLine", width: 3),

        autoHideIcons: false
    )

    static let interstellar = Theme(
        "Interstellar", .init(localized: "Interstellar"),

        headInactive: SymbolIconBuilder(symbol: .globeAmericasFill, configuration: .init(scale: .small), width: 10),
        headActive: .custom(SymbolIconBuilder(symbol: .globeAmericas, configuration: .init(scale: .small), width: 32)),

        body: SymbolIconBuilder(symbol: .sunMaxFill, configuration: .init(scale: .small), width: 10),
        tail: SymbolIconBuilder(
            symbol: .moonphaseWaningGibbous,
            configuration: .init(scale: .small).applying(.preferringHierarchical()),
            width: 10
        ),

        autoHideIcons: true
    )

    static let electrodiagram = Theme(
        "Electrodiagram", .init(localized: "Electrodiagram"),

        headInactive: NamedIconBuilder(name: "DiagramHead", width: 1),
        headActive: .headWithWidth(18),

        body: NamedIconBuilder(name: "Diagram", width: 1),
        tail: NamedIconBuilder(name: "DiagramTail", width: 1),

        autoHideIcons: false
    )

    static let droplets = Theme(
        "Droplets", .init(localized: "Droplets"),

        headInactive: NamedIconBuilder(name: "Drops", width: 6),
        headActive: .headWithWidth(32),

        body: NamedIconBuilder(name: "LDrop", width: 6),
        tail: NamedIconBuilder(name: "MDrop", width: 6),

        autoHideIcons: false
    )

    static let codec = Theme(
        "Codec", .init(localized: "Codec"),

        headInactive: SymbolIconBuilder(
            symbol: .ellipsisCurlybraces,
            configuration: .preferringHierarchical(),
            width: 16
        ),
        headActive: .custom(SymbolIconBuilder(symbol: .curlybraces, width: 22)),

        body: SymbolIconBuilder(symbol: .ellipsis, width: 16),
        tail: SymbolIconBuilder(symbol: .ellipsis, width: 16),

        autoHideIcons: false
    )

    static let colons = Theme(
        "Colons", .init(localized: "Colons"),

        headInactive: NamedIconBuilder(name: "Colon", width: 6),
        headActive: .headWithWidth(16),

        body: NamedIconBuilder(name: "Colon", width: 6),
        tail: NamedIconBuilder(name: "Colon", width: 6),

        autoHideIcons: false
    )

    static let notSoHappy = Theme(
        "NotSoHappy", .init(localized: "Not So Happy"),

        headInactive: NamedIconBuilder(name: "Sad", width: 14),
        headActive: .custom(NamedIconBuilder(name: "Happy", width: 32)),

        body: NamedIconBuilder(name: "Pale", width: 14),
        tail: NamedIconBuilder(name: "Cat", width: 14),

        autoHideIcons: false
    )

    static let playPause = Theme(
        "PlayPause", .init(localized: "Play Pause"),

        headInactive: SymbolIconBuilder(symbol: .playFill, width: 22),
        headActive: .custom(SymbolIconBuilder(symbol: .pauseFill, width: 36)),

        body: SymbolIconBuilder(symbol: .forwardEndFill, width: 22, opacity: 0.2),
        tail: SymbolIconBuilder(symbol: .backwardEndFill, width: 22, opacity: 0.2),

        autoHideIcons: true
    )

    static let theFace = Theme(
        "TheFace", .init(localized: "【=◈︿◈=】"),
        icon: .tail,

        headInactive: NamedIconBuilder(name: "Face", width: 25),
        headActive: .headWithWidth(64),

        body: SymbolIconBuilder(symbol: .musicNote, width: 16),
        tail: SymbolIconBuilder(symbol: .musicQuarternote3, width: 16),

        autoHideIcons: false
    )

    static let theImplied = Theme(
        "Implication", .init(localized: "Implication"),
        icon: .tail,

        headInactive: NamedIconBuilder(name: "Implies", width: 16),
        headActive: .headWithWidth(32),

        body: NamedIconBuilder(name: "Since", width: 16),
        tail: NamedIconBuilder(name: "Therefore", width: 16),

        autoHideIcons: false
    )

    static let macOS = Theme(
        "macOS", .init(localized: "macOS"),
        icon: .custom(SymbolIconBuilder(symbol: .appleLogo, width: 20)),

        headInactive: SymbolIconBuilder(symbol: .chevronBackward, width: 20),

        body: SymbolIconBuilder(symbol: .poweron, width: 20, opacity: 0.5),
        tail: SymbolIconBuilder(symbol: .poweron, width: 20, opacity: 0.2),

        autoHideIcons: true
    )
}

extension Theme {
    static var themes: [Theme] {
        [
            abyssal,
            hiddenBar,
            simplicity,
            approaching,
            metresAway,
            interstellar,
            electrodiagram,
            droplets,
            codec,
            colons,
            notSoHappy,
            playPause,
            theFace,
            theImplied,
            macOS
        ]
    }

    static var defaultTheme: Theme {
        return abyssal
    }

    static var themeIds: [String] {
        return themes.map { $0.id }
    }

    static var themeNames: [String] {
        return themes.map { $0.name }
    }
}

extension Theme: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
