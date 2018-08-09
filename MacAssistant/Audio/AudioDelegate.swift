//
// Created by Vansh Gandhi on 7/26/18.
// Copyright (c) 2018 Vansh Gandhi. All rights reserved.
//

import Foundation

public protocol AudioDelegate {
    func onMicrophoneInputAudio(audioData: Data)
}