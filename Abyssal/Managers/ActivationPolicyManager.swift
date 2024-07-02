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
    private static var fallback: NSApplication.ActivationPolicy = .accessory
    
    static func set(
        _ activationPolicy: NSApplication.ActivationPolicy,
        asFallback: Bool = false,
        deadline: DispatchTime
    ) {
        dispatch = .init() {
            set(activationPolicy, asFallback: asFallback)
        }
        
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: dispatch!)
    }
    
    static func set(
        _ activationPolicy: NSApplication.ActivationPolicy,
        asFallback: Bool = false
    ) {
        cancel()
        NSApp.setActivationPolicy(activationPolicy)
        
        if asFallback {
            fallback = activationPolicy
        }
    }
    
    static func setToFallback(deadline: DispatchTime) {
        set(fallback, deadline: deadline)
    }
    
    static func setToFallback() {
        set(fallback)
    }
    
    static func toggleBetweenFallback(
        _ activationPolicy: NSApplication.ActivationPolicy,
        deadline: DispatchTime
    ) {
        guard activationPolicy != fallback else {
            setToFallback(deadline: deadline)
            return
        }
        
        if NSApp.activationPolicy() == fallback {
            set(activationPolicy, deadline: deadline)
        } else {
            setToFallback(deadline: deadline)
        }
    }
    
    static func toggleBetweenFallback(
        _ activationPolicy: NSApplication.ActivationPolicy
    ) {
        guard activationPolicy != fallback else {
            setToFallback()
            return
        }
        
        if NSApp.activationPolicy() == fallback {
            set(activationPolicy)
        } else {
            setToFallback()
        }
    }
    
    static func cancel() {
        dispatch?.cancel()
        dispatch = nil
    }
}
