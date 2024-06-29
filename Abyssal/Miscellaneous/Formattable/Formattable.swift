//
//  Formattable.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/29.
//

import Foundation

protocol Formattable {
    associatedtype Value: CVarArg
    
    var format: String { get }
    func format(_ values: Value...) -> String
}

extension Formattable {
    func format(_ values: Value...) -> String {
        .init(format: format, values)
    }
}
