//
//  MarginTextFieldCell.swift
//  Abyssal
//
//  Created by KrLite on 2023/10/13.
//

import Foundation
import AppKit

class MarginTextFieldCell: NSTextFieldCell {

    private static let padding = CGSize(width: 24.0, height: 8.0)

    override func cellSize(forBounds rect: NSRect) -> NSSize {
        var size = super.cellSize(forBounds: rect)
        size.width += MarginTextFieldCell.padding.width * 2
        size.height += MarginTextFieldCell.padding.height * 2
        
        return size
    }

    override func titleRect(
        forBounds rect: NSRect
    ) -> NSRect {
        return rect.insetBy(
            dx: MarginTextFieldCell.padding.width,
            dy: MarginTextFieldCell.padding.height
        )
    }

    override func edit(
        withFrame rect: NSRect,
        in controlView: NSView,
        editor textObj: NSText,
        delegate: Any?,
        event: NSEvent?
    ) {
        let insetRect = rect.insetBy(dx: MarginTextFieldCell.padding.width, dy: MarginTextFieldCell.padding.height)
        
        super.edit(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, event: event)
    }

    override func select(
        withFrame rect: NSRect,
        in controlView: NSView,
        editor textObj: NSText,
        delegate: Any?,
        start selStart: Int,
        length selLength: Int
    ) {
        let insetRect = rect.insetBy(dx: MarginTextFieldCell.padding.width, dy: MarginTextFieldCell.padding.height)
        
        super.select(withFrame: insetRect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }

    override func drawInterior(
        withFrame cellFrame: NSRect,
        in controlView: NSView
    ) {
        let insetRect = cellFrame.insetBy(dx: MarginTextFieldCell.padding.width, dy: MarginTextFieldCell.padding.height)
        
        super.drawInterior(withFrame: insetRect, in: controlView)
    }

}
