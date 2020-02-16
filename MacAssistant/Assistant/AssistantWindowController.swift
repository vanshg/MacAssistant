//
//  AssistantWindowController.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 8/3/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa
import SwiftyUserDefaults

class AssistantWindowController: NSWindowController {
    override func windowDidLoad() {
        window?.isMovable = Defaults[\.allowWindowMovement]
        window?.makeKeyAndOrderFront(nil)
        if !Defaults[\.allowWindowLoseFocus] {
            window?.level = .floating
            window?.orderFrontRegardless()
        }
    }
}
