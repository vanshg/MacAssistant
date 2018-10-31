//
// Created by Vansh Gandhi on 7/26/18.
// Copyright (c) 2018 Vansh Gandhi. All rights reserved.
//

import Foundation
import AudioKit

struct AudioConstants {
    public static let NATIVE_SAMPLE_RATE = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate
    public static let GOOGLE_SAMPLE_RATE = Int32(16000) // Hertz
    public static let FRAME_TIME = 0.1 // Seconds
    public static let GOOGLE_SAMPLES_PER_FRAME = Double(GOOGLE_SAMPLE_RATE) * FRAME_TIME
    public static let NATIVE_SAMPLES_PER_FRAME = Double(NATIVE_SAMPLE_RATE) * FRAME_TIME
}
