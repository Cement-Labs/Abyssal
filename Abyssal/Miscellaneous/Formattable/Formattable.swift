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
    
    func eval(_ value: Value) -> Value
}

extension Formattable {
    func format(_ values: Value...) -> String {
        .init(format: format, values.map(eval(_:)))
    }
    
    func eval(_ value: Value) -> Value {
        value
    }
}

protocol DoubleFormattable: Formattable where Value == Double {
}

extension DoubleFormattable {
    func format(_ value: Double) -> String {
        .init(format: format, eval(value))
    }
    
    func eval(_ value: Value) -> Value {
        value.rounded(digits: 1)
    }
}
