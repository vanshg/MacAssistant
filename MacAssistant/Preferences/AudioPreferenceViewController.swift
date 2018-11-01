//
//  AudioPreferenceViewController.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 10/31/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa
import Preferences

final class AudioPreferenceViewController: NSViewController, Preferenceable {
    let toolbarItemTitle = "Audio"
    let toolbarItemIcon = NSImage(named: NSImage.touchBarAudioOutputVolumeMediumTemplateName)!
    
    override var nibName: NSNib.Name {
        return "AudioPreferenceView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup stuff here
    }
}
