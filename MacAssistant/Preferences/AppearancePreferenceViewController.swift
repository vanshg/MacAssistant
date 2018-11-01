//
//  AppearancePreferenceViewController.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 10/31/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa
import Preferences

final class AppearancePreferenceViewController: NSViewController, Preferenceable {
    let toolbarItemTitle = "Appearance"
    let toolbarItemIcon = NSImage(named: NSImage.colorPanelName)!
    
    override var nibName: NSNib.Name {
        return "AppearancePreferenceView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup stuff here
    }
}
