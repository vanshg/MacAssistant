//
//  Assistant.swift
//  AssistantService
//
//  Created by Vansh Gandhi on 7/25/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Foundation
import Log
import SwiftGRPC
import SwiftyUserDefaults

typealias AssistantServiceClient = Google_Assistant_Embedded_V1alpha2_EmbeddedAssistantServiceClient
typealias AssistCall = Google_Assistant_Embedded_V1alpha2_EmbeddedAssistantAssistCall
typealias AudioInConfig = Google_Assistant_Embedded_V1alpha2_AudioInConfig
typealias AudioOut = Google_Assistant_Embedded_V1alpha2_AudioOut
typealias AudioOutConfig = Google_Assistant_Embedded_V1alpha2_AudioOutConfig
typealias AssistRequest = Google_Assistant_Embedded_V1alpha2_AssistRequest
typealias AssistResponse = Google_Assistant_Embedded_V1alpha2_AssistResponse
typealias AssistConfig = Google_Assistant_Embedded_V1alpha2_AssistConfig
typealias SpeechRecognitionResult = Google_Assistant_Embedded_V1alpha2_SpeechRecognitionResult
typealias DialogStateIn = Google_Assistant_Embedded_V1alpha2_DialogStateIn
typealias DialogStateOut = Google_Assistant_Embedded_V1alpha2_DialogStateOut
typealias DeviceConfig = Google_Assistant_Embedded_V1alpha2_DeviceConfig
typealias DeviceLocation = Google_Assistant_Embedded_V1alpha2_DeviceLocation
typealias DeviceAction = Google_Assistant_Embedded_V1alpha2_DeviceAction
typealias ScreenOut = Google_Assistant_Embedded_V1alpha2_ScreenOut
typealias ScreenOutConfig = Google_Assistant_Embedded_V1alpha2_ScreenOutConfig
typealias DebugInfo = Google_Assistant_Embedded_V1alpha2_DebugInfo
typealias DebugConfig = Google_Assistant_Embedded_V1alpha2_DebugConfig

//typealias ClientError = Google_Assistant_Embedded_V1Alpha2_EmbeddedAssistantClientError

public class Assistant {

    private let Log = Logger()
    private let DEBUG = true
    private let ASSISTANT_API_ENDPOINT = "embeddedassistant.googleapis.com"
    private var service: AssistantServiceClient

    public init() {
        service = AssistantServiceClient(address: ASSISTANT_API_ENDPOINT, secure: true)
    }

    func initiateSpokenRequest(delegate: AssistantDelegate) -> AssistCall {
        var request = AssistRequest()
        var config = AssistConfig()
        config.audioOutConfig = getAudioOutConfig()
        config.audioInConfig = getAudioInConfig()
        config.deviceConfig = getDeviceConfig()
        config.debugConfig = getDebugConfig()
        config.dialogStateIn = getDialogStateIn()
        config.screenOutConfig = getScreenOutConfig()
        request.config = config

        let streamCall = try! beginCall(delegate: delegate)
        try! sendRequest(streamCall: streamCall, request: request, delegate: delegate)
        try! continuouslyReceive(streamCall: streamCall, delegate: delegate)

        return streamCall
    }

    func sendAudioChunk(streamCall: AssistCall, audio: Data, delegate: AssistantDelegate) {
        Log.debug("Sending audio chunk")
        var request = AssistRequest()
        request.audioIn = audio
        try! sendRequest(streamCall: streamCall, request: request, delegate: delegate)
    }

    func sendTextQuery(text: String, delegate: AssistantDelegate) {
        Log.debug("sending text query")
        var request = AssistRequest()
        var config = AssistConfig()
        config.audioOutConfig = getAudioOutConfig()
        config.dialogStateIn = getDialogStateIn()
        config.deviceConfig = getDeviceConfig()
        config.debugConfig = getDebugConfig()
        config.screenOutConfig = getScreenOutConfig()
        config.textQuery = text
        request.config = config

        let streamCall = try! beginCall(delegate: delegate)
        try! sendRequest(streamCall: streamCall, request: request, delegate: delegate)
        try! continuouslyReceive(streamCall: streamCall, delegate: delegate)
    }

    private func beginCall(delegate: AssistantDelegate) throws -> AssistCall {
        service.metadata = try! Metadata(["authorization": "Bearer \(Defaults[.accessToken])"])
        return try service.assist() { result in
            // This is called after the stream is finished
            delegate.onAssistantCallCompleted(result: result)
        }
    }

    private func sendRequest(streamCall: AssistCall, request: AssistRequest, delegate: AssistantDelegate) throws {
        try streamCall.send(request) { err in
            if let error = err {
                delegate.onError(error: error)
            }
        }
    }
    
    private func closeSend(streamCall: AssistCall) throws {
        try streamCall.closeSend() {
            self.Log.debug("Closed sending channel")
        }
    }
    
    private func continuouslyReceive(streamCall: AssistCall, delegate: AssistantDelegate) throws {
        let audioOutData = NSMutableData()
        DispatchQueue.main.async {
            while true {
                do {
                    let response = try streamCall.receive()
                    if let response = response {
                        if response.hasDialogStateOut {
                            let dialogStateOut = response.dialogStateOut
                            Defaults[.conversationState] = dialogStateOut.conversationState
                            delegate.onDisplayText(text: dialogStateOut.supplementalDisplayText)
                            
                            if dialogStateOut.volumePercentage != 0 {
                                self.Log.debug("Set volume")
                                // TODO: set computer's volume percentage
                            }
                            
                            if dialogStateOut.microphoneMode == .dialogFollowOn {
                                delegate.onFollowUpRequired()
                            }
                        }
                        
                        if response.hasScreenOut {
                            let screenOut = response.screenOut
                            assert(screenOut.format == .html)
                            delegate.onScreenOut(htmlData: String(data: screenOut.data, encoding: .utf8)!)
                        }
                        
                        if response.speechResults.count > 0 {
                            var transcript = ""
                            for speechResult in response.speechResults {
                                transcript.append(speechResult.transcript)
                            }
                            delegate.onTranscriptUpdate(transcript: transcript)
                        }
                        
                        if response.hasAudioOut {
                            audioOutData.append(response.audioOut.audioData)
                        }
                        
                        if response.eventType == .endOfUtterance {
                            self.Log.debug("Got end of utterance")
                            try self.closeSend(streamCall: streamCall)
                            delegate.onDoneListening()
                        }
                    } else {
//                        delegate.onDoneListening()
                        break // If no error, but response was nil, we are done receiving
                    }
                    
                } catch {
                    delegate.onError(error: error)
                }
            }
            
            if audioOutData.length > 0 {
                delegate.onAudioOut(audio: audioOutData as Data)
            }
        }
    }

    private func getDeviceConfig() -> Google_Assistant_Embedded_V1alpha2_DeviceConfig {
        var deviceConfig = DeviceConfig()
        deviceConfig.deviceModelID = "macassistant-165919_macos"
        deviceConfig.deviceID = "macassistant"
        return deviceConfig
    }

    private func getDialogStateIn() -> DialogStateIn {
        var dialogStateIn = DialogStateIn()
        dialogStateIn.languageCode = getLanguageCode()
        dialogStateIn.isNewConversation = getIsNewConversation()
        dialogStateIn.conversationState = Defaults[.conversationState]

        if let location = getDeviceLocation() {
            dialogStateIn.deviceLocation = location
        }

        return dialogStateIn
    }

    private func getIsNewConversation() -> Bool {
        // return true if window reopened
        return true
    }

    private func getDeviceLocation() -> DeviceLocation? {
        return nil
        // TODO: Implement me based on Location Services (or manually set location)
    }

    private func getAudioInConfig() -> AudioInConfig {
        var audioInConfig = AudioInConfig()
        audioInConfig.sampleRateHertz = AudioConstants.GOOGLE_SAMPLE_RATE
        audioInConfig.encoding = .linear16
        return audioInConfig
    }

    private func getAudioOutConfig() -> AudioOutConfig {
        var audioOutConfig = AudioOutConfig()
        audioOutConfig.encoding = .mp3
        audioOutConfig.volumePercentage = 100 // TODO: Take from settings?
        audioOutConfig.sampleRateHertz = AudioConstants.GOOGLE_SAMPLE_RATE
        return audioOutConfig
        // TODO: Implement me based on hardware capability
    }

    private func getScreenOutConfig() -> ScreenOutConfig {
        var screenOutConfig = ScreenOutConfig()
        screenOutConfig.screenMode = .off
        return screenOutConfig
        // TODO: Implement me based on User Preferences
    }

    private func getLanguageCode() -> String {
        return "en-US"
        // TODO: Implement me based on User Preferences (with option of using manual override or system language)
    }

    private func getDebugConfig() -> DebugConfig {
        var debugConfig = DebugConfig()
        debugConfig.returnDebugInfo = DEBUG
        return debugConfig
    }
}
