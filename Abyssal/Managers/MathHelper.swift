//
//  MathHelper.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/24.
//

import Foundation

struct MathHelper {
    static var lerpThreshold: CGFloat {
        guard let width = ScreenManager.width else { return 75 }
        return width / 25
    }
    
    static var lerpRatio: CGFloat {
        let baseValue = 0.42
        return baseValue * (KeyboardManager.shift ? 0.25 : 1) // Slow down when shift key is down
    }
    
    static func approaching(
        _ a: CGFloat, _ b: CGFloat,
        _ ignoreSmallValues: Bool = true
    ) -> Bool {
        abs(a - b) < (ignoreSmallValues ? 1 : 0.001)
    }
    
    static func lerp(
        a:      CGFloat,
        b:      CGFloat,
        ratio:  CGFloat,
        _ ignoreSmallValues: Bool = true
    ) -> CGFloat {
        guard !ignoreSmallValues || !approaching(a, b, ignoreSmallValues) else { return b }
        let diff = b - a
        
        return a + log10ClampWithThreshold(diff, threshold: lerpThreshold) * ratio
    }
    
    static func log10ClampWithThreshold(
        _ x: CGFloat,
        threshold: CGFloat
    ) -> CGFloat {
        if x < -threshold {
            return -(threshold + log10(-x / threshold) * threshold)
        } else if x > threshold {
            return threshold + log10(x / threshold) * threshold
        } else {
            return x
        }
    }
}
