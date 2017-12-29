//
//  rpcBindings.swift
//  MacAssistant
//
//  Created by Vansh on 4/28/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Foundation
import gRPC
import Log

typealias AssistantService = Google_Assistant_Embedded_V1Alpha2_EmbeddedAssistantService
typealias AssistantCall = Google_Assistant_Embedded_V1Alpha2_EmbeddedAssistantAssistCall
typealias AudioInConfig = Google_Assistant_Embedded_V1alpha2_AudioInConfig
typealias AudioOutConfig = Google_Assistant_Embedded_V1alpha2_AudioOutConfig
typealias AssistRequest = Google_Assistant_Embedded_V1alpha2_AssistRequest
typealias AssistResponse = Google_Assistant_Embedded_V1alpha2_AssistResponse
typealias AssistConfig = Google_Assistant_Embedded_V1alpha2_AssistConfig
typealias ClientError = Google_Assistant_Embedded_V1Alpha2_EmbeddedAssistantClientError
typealias DialogStateIn = Google_Assistant_Embedded_V1alpha2_DialogStateIn
typealias DialogStateOut = Google_Assistant_Embedded_V1alpha2_DialogStateOut
typealias DeviceAction = Google_Assistant_Embedded_V1alpha2_DeviceAction

class API {
    
    private let Log = Logger()
    private let userDefaults = UserDefaults.standard
    private let ASSISTANT_API_ENDPOINT = "embeddedassistant.googleapis.com"
    private var service: AssistantService
    private var currentCall: AssistantCall?
    private var dialogStateIn: DialogStateIn
    private var delegate: ConversationTextDelegate
    private var followUp = false
    private var buf = NSMutableData()
    private var conversationState: Data {
        get {
            return userDefaults.data(forKey: Constants.CONVERSATION_STATE_KEY) ?? Data()
        }
        set {
            userDefaults.set(newValue, forKey: Constants.CONVERSATION_STATE_KEY)
            dialogStateIn.conversationState = newValue
        }
    }
    
    public init(_ delegate: ConversationTextDelegate) {
        let certUrl = Bundle.main.url(forResource: "roots", withExtension: "pem")!
        let certificate = try! String(contentsOf: certUrl)
        service = AssistantService(address: ASSISTANT_API_ENDPOINT, certificates: certificate, host: nil)
        self.delegate = delegate
        dialogStateIn = DialogStateIn()
        dialogStateIn.conversationState = conversationState
    }
    
    func initiateRequest(volumePercent: Int32) {
        // always have the most up-to-date metadata, because token may have been refreshed 
        let token = "Bearer \(UserDefaults.standard.string(forKey: Constants.AUTH_TOKEN_KEY) ?? "")"
        service.metadata = Metadata(["authorization" : token])
        
        var request = AssistRequest()
        request.config = AssistConfig()
//        request.config.textQuery = "What time is it?"
        
        var audioInConfig = AudioInConfig()
        audioInConfig.sampleRateHertz = Int32(Constants.GOOGLE_SAMPLE_RATE)
        audioInConfig.encoding = .linear16
        request.config.audioInConfig = audioInConfig
        request.config.dialogStateIn = dialogStateIn
        
        var audioOutConfig = AudioOutConfig()
        audioOutConfig.sampleRateHertz = Int32(Constants.GOOGLE_SAMPLE_RATE) // TODO: Play back the response and find the appropriate value
        audioOutConfig.encoding = .mp3
        audioOutConfig.volumePercentage = volumePercent
        request.config.audioOutConfig = audioOutConfig
        
        do {
            currentCall = try service.assist(completion: { _ in self.Log.debug("Call completed") })
            try currentCall?.send(request) { self.Log.error("Initial send error", $0) }
            try currentCall?.receive(completion: onReceive)
        } catch { Log.error("Initial catch", error, error.localizedDescription) }
    }
    
    func sendAudio(frame data: UnsafePointer<UnsafeMutablePointer<Int16>>, withLength length: Int) {
        var request = AssistRequest()
        let buffer = UnsafeMutableBufferPointer(start: data[0], count: length) // convert from UnsafePointer to BufferPointer
        let data = Data(buffer: buffer) // Wrap Buffer in Data
        request.audioIn = data
        // Don't call currentCall?.receive() in here. Causes tooManyOperations error
        do {
            try currentCall?.send(request) {
                self.Log.error("Frame send error", $0.localizedDescription)
            }
        }
        catch { Log.error("Frame catch", error, error.localizedDescription) }
    }
    
    func doneSpeaking() {
        do {
            try currentCall?.closeSend { self.Log.info("Closed send") }
            // Receive all response audio responses
            DispatchQueue.global().async {
                while true {
                    do {
                        try self.currentCall?.receive(completion: self.onReceive)
                        let response = try self.currentCall?.receive()
                        self.onReceive(response: response, error: nil)
                    } catch {
                        self.Log.error("close catch", error, error.localizedDescription)
                        break
                    }
                }
                if (self.buf.length > 0) {
                    self.delegate.playResponse(self.buf as Data)
                    self.buf.length = 0
                }
            }
            
        } catch {
            Log.error("Close catch", error, error.localizedDescription)
        }
    }
    
    private func onReceive(response: AssistResponse?, error: ClientError?) {
        if let response = response {
            Log.debug("Received response")
            self.followUp = response.dialogStateOut.microphoneMode == .dialogFollowOn
            
            if !response.dialogStateOut.conversationState.isEmpty {
                conversationState = response.dialogStateOut.conversationState
            }
            
            self.delegate.updateRequestText(response.speechResults.map{ $0.transcript }.joined(separator: " "))
            self.delegate.updateResponseText(response.dialogStateOut.supplementalDisplayText.isEmpty ? "Speaking response..." : response.dialogStateOut.supplementalDisplayText)
            if response.audioOut.audioData.count > 0 { buf.append(response.audioOut.audioData) }
            if response.eventType == .endOfUtterance { self.delegate.stopListening() }
        }
        if let error = error { Log.error("Initial receive error", error, error.localizedDescription) }
    }
    
    func donePlayingResponse() {
        if followUp {
            delegate.startListening()
            followUp = false
        }
    }
}
