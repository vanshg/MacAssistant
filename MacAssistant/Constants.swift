//
//  Constants.swift
//  MacAssistant
//
//  Created by Vansh on 5/3/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Foundation

struct Constants {
    // User Defaults Keys
    public static let LOGGED_IN_KEY = "logged_in"
    public static let AUTH_TOKEN_KEY = "auth_token"
    public static let REFRESH_TOKEN_KEY = "refresh_token"
    public static let EXPIRES_IN_KEY = "expires_in"
    public static let PLAY_PROMPT_KEY = "play_prompt"
    
    public static let NATIVE_SAMPLE_RATE = 44100 // TODO: See if this value works on all Macs
    public static let GOOGLE_SAMPLE_RATE = 16000 // Hertz
    public static let FRAME_TIME = 0.1 // Seconds
    public static let GOOGLE_SAMPLES_PER_FRAME = Double(GOOGLE_SAMPLE_RATE) * FRAME_TIME
    public static let NATIVE_SAMPLES_PER_FRAME = Double(NATIVE_SAMPLE_RATE) * FRAME_TIME
}
