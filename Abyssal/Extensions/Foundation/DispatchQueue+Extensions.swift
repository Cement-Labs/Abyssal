//
//  DispatchQueue+Extensions.swift
//  Abyssal
//
//  Created by KrLite on 2024/7/24.
//

import Foundation

var dispatches: [DispatchQueue: [AnyHashable: DispatchWorkItem]] = [:]

extension DispatchQueue {
    var dispatches: [AnyHashable: DispatchWorkItem] {
        get {
            if let result = Abyssal.dispatches[self] {
                return result
            } else {
                Abyssal.dispatches[self] = [:]
                return [:]
            }
        }

        set {
            Abyssal.dispatches[self] = newValue
        }
    }

    func asyncAfter(
        _ identifier: AnyHashable,
        deadline: DispatchTime,
        execute work: @escaping @Sendable @convention(block) () -> Void
    ) {
        let dispatch = DispatchWorkItem {
            self.cancel(identifier)
            work()
        }

        dispatches[identifier] = dispatch
        asyncAfter(deadline: deadline, execute: dispatch)
    }

    func async(
        _ identifier: AnyHashable,
        execute work: @escaping @Sendable @convention(block) () -> Void
    ) {
        let dispatch = DispatchWorkItem {
            self.cancel(identifier)
            work()
        }

        dispatches[identifier] = dispatch
        async(execute: dispatch)
    }

    func cancel(_ identifier: AnyHashable) {
        dispatches[identifier]?.cancel()
        dispatches[identifier] = nil
    }
}
