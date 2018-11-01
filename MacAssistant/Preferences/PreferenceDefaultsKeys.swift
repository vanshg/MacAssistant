//
//  PreferenceDefaultsKeys.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 11/1/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import SwiftyUserDefaults

// If any keys here are changed, they should be changed in their respective Nib files, along with their default values!
extension DefaultsKeys {
    // General
    
    // Appearance
    static let allowWindowLoseFocus = DefaultsKey<Bool>("allowWindowLoseFocus", defaultValue: false)
    static let allowWindowMovement = DefaultsKey<Bool>("allowWindowMovement", defaultValue: false)
    static let colorTheme = DefaultsKey<String>("colorTheme", defaultValue: "Dark") // One of: "System", "Light", "Dark"
    static let designTheme = DefaultsKey<String>("designTheme", defaultValue: "Apple") // One of: "Apple", "Google (Material Design)"
    
    // Audio
    static let shouldPlayPrompts = DefaultsKey<Bool>("shouldPlayPrompts", defaultValue: true)
    static let shouldSpeakResponses = DefaultsKey<Bool>("shouldSpeakResponses", defaultValue: true)
    static let shouldListenOnMenuClick = DefaultsKey<Bool>("shouldListenOnMenuClick", defaultValue: true)
    
    // Account
    static let shouldUseCustomOAuth = DefaultsKey<Bool>("shouldUseCustomOAuth", defaultValue: false)
    static let customOAuthJSON = DefaultsKey<String>("customOAuthJSON") // TODO: Validate custom OAuth contents
}
