//
//  WindowInfo.swift
//  Abyssal
//
//  Created by KrLite on 2024/6/30.
//

import AppKit
import CoreGraphics

// https://stackoverflow.com/a/77304045/23452915
struct WindowInfo {
    static var allOnScreenWindows: [WindowInfo] {
        let windowInfoDicts = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [NSDictionary]
        return windowInfoDicts.map(WindowInfo.init)
    }
    
    let name: String?
    let ownerName: String
    let ownerProcessID: pid_t
    let layer: Int
    let bounds: NSRect
    let alpha: Double
    let isOnscreen: Bool
    let memoryUsage: Measurement<UnitInformationStorage>
    let windowNumber: Int
    let sharingState: CGWindowSharingType
    let backingStoreType: CGWindowBackingType
    let otherAttributes: NSDictionary
    var isStatusMenuItem: Bool { layer == 25 }
    var isThirdPartyItem: Bool { ownerName != "SystemUIServer" && ownerName != "Control Center" }
    var isFromAbyssal: Bool { ownerProcessID == ProcessInfo.processInfo.processIdentifier }
}

extension WindowInfo {
    init(fromDict dict: NSDictionary) {
        let boundsDict = dict[kCGWindowBounds] as! NSDictionary
        
        var bounds = NSRect()
        assert(CGRectMakeWithDictionaryRepresentation(boundsDict, &bounds))
        
        let otherAttributes = NSMutableDictionary(dictionary: dict)
        otherAttributes.removeObjects(forKeys: [
            kCGWindowName,
            kCGWindowOwnerName,
            kCGWindowOwnerPID,
            kCGWindowLayer,
            kCGWindowBounds,
            kCGWindowAlpha,
            kCGWindowIsOnscreen,
            kCGWindowMemoryUsage,
            kCGWindowNumber,
            kCGWindowSharingState,
            kCGWindowStoreType,
        ])
        
        self.init(
            name: dict[kCGWindowName] as! String?,
            ownerName: dict[kCGWindowOwnerName] as! String,
            ownerProcessID: dict[kCGWindowOwnerPID] as! pid_t,
            layer: dict[kCGWindowLayer] as! Int,
            bounds: bounds,
            alpha: dict[kCGWindowAlpha] as! Double,
            isOnscreen: dict[kCGWindowIsOnscreen] as! Bool,
            memoryUsage: Measurement<UnitInformationStorage>(value: dict[kCGWindowMemoryUsage] as! Double, unit: .bytes),
            windowNumber: dict[kCGWindowNumber] as! Int,
            sharingState: CGWindowSharingType(rawValue: dict[kCGWindowSharingState] as! UInt32)!,
            backingStoreType: CGWindowBackingType(rawValue: dict[kCGWindowStoreType] as! UInt32)!,
            otherAttributes: otherAttributes
        )
    }
}

extension WindowInfo {
    var processRelatedWindows: [WindowInfo] {
        WindowInfo.allOnScreenWindows
            .filter { $0.ownerProcessID == ownerProcessID }
            .filter { $0.windowNumber != windowNumber }
    }
    
    var containsMouse: Bool {
        // Change mouse coordinate (with an upside y-axis) to screen coordinate (with a down y-axis)
        let mouseInScreen = NSEvent.mouseLocation
            .applying(.init(translationX: 0, y: -ScreenManager.frame.height))
            .applying(.init(scaleX: 1, y: -1))
        
        return bounds.contains(mouseInScreen)
    }
    
    func isPlacingNear(_ rect: NSRect, edge: NSRectEdge) -> Bool {
        let gap: Double = 25
        switch edge {
        case .minX:
            let verticallyOK = inGap(bounds.maxX, rect.minX, gap: gap)
            let horizontallyOK = bounds.minY <= rect.minY && bounds.maxY >= rect.maxY
            return verticallyOK && horizontallyOK
        case .minY:
            let verticallyOK = inGap(bounds.maxY, rect.minY, gap: gap)
            let horizontallyOK = bounds.minX <= rect.minX && bounds.maxX >= rect.maxX
            return verticallyOK && horizontallyOK
        case .maxX:
            let verticallyOK = inGap(bounds.minX, rect.maxX, gap: gap)
            let horizontallyOK = bounds.minY <= rect.minY && bounds.maxY >= rect.maxY
            return verticallyOK && horizontallyOK
        case .maxY:
            let verticallyOK = inGap(bounds.minY, rect.maxY, gap: gap)
            let horizontallyOK = bounds.minX <= rect.minX && bounds.maxX >= rect.maxX
            return verticallyOK && horizontallyOK
        @unknown default:
            return false
        }
    }
    
    private func inGap(_ a: Double, _ b: Double, gap: Double) -> Bool {
        abs(a - b) <= abs(gap)
    }
}
