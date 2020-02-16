//
//  AudioPreferenceViewController.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 10/31/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa
import Preferences

final class AudioPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.audio
    let preferencePaneTitle = PreferencePane.Identifier.audio.rawValue
    let toolbarItemIcon = NSImage(named: NSImage.touchBarAudioOutputVolumeMediumTemplateName)!
    
    override var nibName: NSNib.Name { "AudioPreferenceView" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup stuff here
    }
}
