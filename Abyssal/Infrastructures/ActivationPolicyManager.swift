//
//  ActivationPolicyManager.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/23.
//

import Foundation
import AppKit

struct ActivationPolicyManager {
    private static var dispatch: DispatchWorkItem?
    
    static func set(
        _ activationPolicy: NSApplication.ActivationPolicy,
        deadline: DispatchTime = .now()
    ) {
        cancel()
        dispatch = .init() {
            NSApplication.shared.setActivationPolicy(activationPolicy)
        }
        
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: dispatch!)
    }
    
    static func cancel() {
        dispatch?.cancel()
        dispatch = nil
    }
}
