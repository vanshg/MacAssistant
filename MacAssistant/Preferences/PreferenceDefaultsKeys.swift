//
//  PreferenceDefaultsKeys.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 11/1/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import SwiftyUserDefaults
import Preferences

// If any keys here are changed, they should be changed in their respective Nib files, along with their default values!
extension DefaultsKeys {
    // General
    
    // Appearance
    var allowWindowLoseFocus: DefaultsKey<Bool> { .init("allowWindowLoseFocus", defaultValue: false) }
    var allowWindowMovement: DefaultsKey<Bool> { .init("allowWindowMovement", defaultValue: false) }
    var colorTheme: DefaultsKey<String> { .init("colorTheme", defaultValue: "Dark") } // One of: "System", "Light", "Dark"
    var designTheme: DefaultsKey<String> { .init("designTheme", defaultValue: "Apple") } // One of: "Apple", "Google (Material Design) }"
    
    // Audio
    var shouldPlayPrompts: DefaultsKey<Bool> { .init("shouldPlayPrompts", defaultValue: true) }
    var shouldSpeakResponses: DefaultsKey<Bool> { .init("shouldSpeakResponses", defaultValue: true) }
    var shouldListenOnMenuClick: DefaultsKey<Bool> { .init("shouldListenOnMenuClick", defaultValue: true) }
    
    // Account
    var shouldUseCustomOAuth: DefaultsKey<Bool> { .init("shouldUseCustomOAuth", defaultValue: false) }
    var customOAuthJSON: DefaultsKey<String?> { .init("customOAuthJSON") } // TODO: Validate custom OAuth contents
}
