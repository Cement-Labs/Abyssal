//
//  NSRect+Extension.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/17.
//

import AppKit
import Foundation

extension NSRect {
    var containsMouse: Bool {
        MouseModel.shared.inside(self)
    }

    func getTrackingArea(
        _ owner: Any?,
        viewToAdd view: NSView? = nil
    ) -> NSTrackingArea {
        let trackingArea = NSTrackingArea(
            rect: self,
            options: [.activeAlways,
                      .inVisibleRect,
                      .mouseEnteredAndExited],
            owner: owner
        )

        if view != nil {
            view?.addTrackingArea(trackingArea)
        }

        return trackingArea
    }
}
