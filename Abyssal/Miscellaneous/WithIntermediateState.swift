//
//  WithIntermediateState.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/30.
//

import Foundation

struct WithIntermediateState<Value> where Value: Equatable {
    var intermediate: Value?
    var value: () -> Value
    
    var needsUpdate: Bool {
        intermediate != value()
    }
    
    init(_ value: @escaping () -> Value) {
        self.value = value
        self.intermediate = nil
    }
    
    mutating func update(_ value: @escaping () -> Value) {
        intermediate = self.value()
        self.value = value
    }
}
