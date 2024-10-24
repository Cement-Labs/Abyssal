//
//  LuminareManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/10/20.
//

import Foundation
import Luminare
import SwiftUI
import SFSafeSymbols
import Defaults

extension String: @retroactive Identifiable {
    public var id: String { self }
}

enum Tab: LuminareTabItem, CaseIterable {
    case appearance
    case functions
    
    case permissions
    case about
    
    var title: String {
        switch self {
        case .appearance:
                .init(localized: "Appearance")
        case .functions:
                .init(localized: "Functions")
        case .permissions:
                .init(localized: "Permissions")
        case .about:
                .init(localized: "About")
        }
    }
    
    var icon: Image {
        let symbol: SFSymbol = switch self {
        case .appearance: .pencilAndOutline
        case .functions: .function
        case .permissions: .lockCircleDotted
        case .about: .infoCircle
        }
        return Image(systemSymbol: symbol)
    }
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .appearance: AppearanceView()
        case .functions: FunctionsView()
        case .permissions: PermissionsView()
        case .about: AboutView()
        }
    }
    
    static let customization: [Self] = [.appearance, .functions]
    static let app: [Self] = [.permissions, .about]
}

extension Tab: Identifiable {
    var id: String {
        .init(describing: self)
    }
}

class LuminareManager {
    static var luminare: LuminareWindow?
    static var isOpened: Bool {
        luminare?.isVisible ?? false
    }
    
    static func open() {
        if luminare == nil {
            LuminareConstants.tint = {
                AbyssalApp.isActive ? .accentColor : .gray
            }
            luminare = LuminareWindow(blurRadius: 20) {
                LuminareContentView()
            }
            luminare?.center()
            luminare?.becomeKey()
        }
        
        luminare?.show()
        app.mainMenu = appMainMenu
        
        AbyssalApp.isActive = true
        ActivationPolicyManager.set(.regular)
        NSApp.activate()
    }
    
    static func close() {
        luminare?.close()
        luminare = nil
        app.mainMenu = nil
        
        AbyssalApp.isActive = false
        ActivationPolicyManager.setToFallback()
    }
    
    static func toggle() {
        if isOpened {
            close()
        } else {
            open()
        }
    }
}

struct LuminareContentView: View {
    @State private var currentTab: Tab = .appearance
    
    @Default(.isStandby) private var isStandby
    
    var body: some View {
        LuminareDividedStack {
            LuminareSidebar {
                LuminareSidebarSection("Customization", selection: $currentTab, items: Tab.customization)
                LuminareSidebarSection("\(Bundle.main.appName)", selection: $currentTab, items: Tab.app)
                
                Spacer()
            }
            .frame(width: 260)
            
            LuminarePane {
                HStack {
                    currentTab.iconView()
                    
                    Text(currentTab.title)
                        .font(.title2)
                    
                    Spacer()
                }
            } content: {
                currentTab.view()
                    .transition(.blurReplace().animation(.default))
            }
            .frame(width: 390)
        }
    }
}
