//
// Created by Vansh Gandhi on 7/26/18.
// Copyright (c) 2018 Vansh Gandhi. All rights reserved.
//

import Foundation
import GRPC

protocol AssistantDelegate {
    func onAssistantCallCompleted(result: AssistResponse)
    func onDoneListening()
    func onDisplayText(text: String)
    func onScreenOut(htmlData: String)
    func onTranscriptUpdate(transcript: String)
    func onAudioOut(audio: Data)
    func onFollowUpRequired()
    func onError(error: Error)
}
