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

enum LuminareTab: LuminareTabItem, CaseIterable {
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

extension LuminareTab: Identifiable {
    var id: String {
        .init(describing: self)
    }
}

class LuminareManager {
    static var luminare: LuminareWindow?
    static var model = LuminareWindowModel()
    static var isOpened: Bool {
        luminare?.isVisible ?? false
    }
    
    static func open(with tab: LuminareTab = .appearance) {
        if luminare == nil {
            LuminareConstants.tint = {
                AbyssalApp.isActive ? .accentColor : .gray
            }
            luminare = LuminareWindow(blurRadius: 20) {
                LuminareContentView(model: model)
            }
            luminare?.center()
            luminare?.becomeKey()
        }
        
        model.currentTab = tab
        
        luminare?.show()
        app.mainMenu = appMainMenu
        
        AbyssalApp.isActive = true
    }
    
    static func close() {
        luminare?.close()
        luminare = nil
        app.mainMenu = nil
        
        AbyssalApp.isActive = false
    }
    
    static func toggle() {
        if isOpened {
            close()
        } else {
            open()
        }
    }
}

class LuminareWindowModel: ObservableObject {
    @Published var currentTab: LuminareTab = .appearance
}

struct LuminareContentView: View {
    @ObservedObject var model: LuminareWindowModel
    
    @Default(.isStandby) private var isStandby
    
    var body: some View {
        LuminareDividedStack {
            LuminareSidebar {
                LuminareSidebarSection("Customization", selection: $model.currentTab, items: LuminareTab.customization)
                LuminareSidebarSection("\(Bundle.main.appName)", selection: $model.currentTab, items: LuminareTab.app)
                
                Spacer()
            }
            .frame(width: 260)
            
            LuminarePane {
                HStack {
                    model.currentTab.iconView()
                    
                    Text(model.currentTab.title)
                        .font(.title2)
                    
                    Spacer()
                }
            } content: {
                model.currentTab.view()
                    .transition(.blurReplace().animation(.default))
            }
            .frame(width: 390)
        }
    }
}
