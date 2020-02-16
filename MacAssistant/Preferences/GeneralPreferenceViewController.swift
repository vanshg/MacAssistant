//
//  GeneralPreferenceViewController.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 10/31/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.general
    let preferencePaneTitle = PreferencePane.Identifier.general.rawValue
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    
    override var nibName: NSNib.Name { "GeneralPreferenceView" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup stuff here
    }
}
