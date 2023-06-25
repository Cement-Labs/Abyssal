//
//  Number+Extension.swift
//  Stalker
//
//  Created by KrLite on 2023/6/25.
//

import Foundation

extension Int64 {
    
    var float16: Float16 {
        return Float16(self)
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
}

extension Float16 {
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
}

extension CGFloat {
    
    var float16: Float16 {
        return Float16(self)
    }
    
}
