//
//  AssistantWindowController.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 8/3/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa

class AssistantWindowController: NSWindowController {
    override func windowDidLoad() {
        window?.isMovable = false
        window?.level = .floating
        window?.makeKeyAndOrderFront(nil)
        window?.orderFrontRegardless()
    }
}
