//
//  AccountPreferenceViewController.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 10/31/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa
import Preferences

final class AccountPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.account
    let preferencePaneTitle = PreferencePane.Identifier.account.rawValue
    let toolbarItemIcon = NSImage(named: NSImage.userGroupName)!
    
    override var nibName: NSNib.Name { "AccountPreferenceView" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup stuff here
    }
}
