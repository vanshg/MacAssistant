//
//  SettingsViewController.swift
//  MacAssistant
//
//  Created by Vansh on 5/22/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Foundation
import Cocoa
import Log

class PreferencesWindowController: NSWindowController {
    
    let Log = Logger()
    
    @IBAction func didClickAdvancedTab(_ sender: Any) {
        Log.debug("Advanced")
    }
    
    @IBAction func didClickGeneralTab(_ sender: Any) {
        Log.debug("General")
    }
    
    
}
