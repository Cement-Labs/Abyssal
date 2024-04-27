//
//  Icon.swift
//  Abyssal
//
//  Created by KrLite on 2024/4/27.
//

import Foundation
import AppKit
import SFSafeSymbols

protocol Icon {
    var image: NSImage { get }
    var width: CGFloat { get }
    var opacity: CGFloat { get }
}

struct NamedIcon: Icon {
    var name: String
    
    var image: NSImage {
        .init(named: .init(name))!
    }
    
    var width: CGFloat
    var opacity: CGFloat = 1
}

struct SymbolIcon: Icon {
    var symbol: SFSymbol
    var configuration: NSImage.SymbolConfiguration?
    
    var image: NSImage {
        let image = NSImage(systemSymbol: symbol)
        
        if
            let configuration,
            let image = image.withSymbolConfiguration(configuration)
        {
            return image
        } else {
            return image
        }
    }
    
    var width: CGFloat
    var opacity: CGFloat = 1
}

protocol IconBuilder {
    associatedtype Target: Icon
    
    var width: CGFloat { get }
    var opacity: CGFloat { get }
    
    func build(identifier: String) -> Target
    func build(identifier: String, width: CGFloat) -> Target
}

extension IconBuilder {
    func build(identifier: String) -> Target {
        build(identifier: identifier, width: width)
    }
}

struct NamedIconBuilder: IconBuilder {
    typealias Target = NamedIcon
    
    var name: String
    var width: CGFloat
    var opacity: CGFloat = 1
    
    func build(identifier: String, width: CGFloat) -> NamedIcon {
        .init(name: "Themes/\(identifier)/" + name, width: width, opacity: opacity)
    }
}

struct SymbolIconBuilder: IconBuilder {
    typealias Target = SymbolIcon
    
    var symbol: SFSymbol
    var configuration: NSImage.SymbolConfiguration?
    var width: CGFloat
    var opacity: CGFloat = 1
    
    func build(identifier: String, width: CGFloat) -> SymbolIcon {
        .init(symbol: symbol, configuration: configuration, width: width, opacity: opacity)
    }
}
