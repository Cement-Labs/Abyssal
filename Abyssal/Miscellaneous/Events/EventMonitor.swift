//
//  EventMonitor.swift
//  Abyssal
//
//  Created by KrLite on 2023/6/13.
//

import AppKit
import Cocoa

public class EventMonitor {
    private var monitor: Any?

    private let mask: NSEvent.EventTypeMask

    private let handler: (
        NSEvent?
    ) -> ()

    public init(
        mask: NSEvent.EventTypeMask,
        handler: @escaping (NSEvent?) -> ()
    ) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    public func start(
    ) {
        monitor = NSEvent.addGlobalMonitorForEvents(
            matching: mask,
            handler: handler
        )
    }

    public func stop(
    ) {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
