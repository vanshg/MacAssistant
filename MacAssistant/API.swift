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

typealias AssistantService = Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantService
typealias AssistantCall = Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantConverseCall
typealias AudioInConfig = Google_Assistant_Embedded_V1alpha1_AudioInConfig
typealias AudioOutConfig = Google_Assistant_Embedded_V1alpha1_AudioOutConfig
typealias ConverseRequest = Google_Assistant_Embedded_V1alpha1_ConverseRequest
typealias ConverseConfig = Google_Assistant_Embedded_V1alpha1_ConverseConfig
typealias ConverseReponse = Google_Assistant_Embedded_V1alpha1_ConverseResponse
typealias ClientError = Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantClientError
typealias ConverseState = Google_Assistant_Embedded_V1alpha1_ConverseState

class API {
    
    let Log = Logger()
    
    private let ASSISTANT_API_ENDPOINT = "embeddedassistant.googleapis.com"
    private var service: AssistantService
    private var currentCall: AssistantCall?
    private var converseState: ConverseState?
    private var delegate: ConversationTextDelegate
    private var followUp = false
    private var buf = NSMutableData()
    
    public init(_ delegate: ConversationTextDelegate) {
        let u = Bundle.main.url(forResource: "roots", withExtension: "pem")!
        let certificate = try! String(contentsOf: u)
        service = AssistantService(address: ASSISTANT_API_ENDPOINT, certificates: certificate, host: nil)
        self.delegate = delegate
    }
    
    func initiateRequest(volumePercent: Int32) {
        // always have the most up-to-date metadata, because token may have been refreshed 
        let token = "Bearer \(UserDefaults.standard.string(forKey: Constants.AUTH_TOKEN_KEY) ?? "")"
        service.metadata = Metadata(["authorization" : token])
        
        var request = ConverseRequest()
        request.config = ConverseConfig()
        
        var audioInConfig = AudioInConfig()
        audioInConfig.sampleRateHertz = Int32(Constants.GOOGLE_SAMPLE_RATE)
        audioInConfig.encoding = .linear16
        request.config.audioInConfig = audioInConfig
        request.config.converseState = converseState ?? request.config.converseState        
        
        var audioOutConfig = AudioOutConfig()
        audioOutConfig.sampleRateHertz = Int32(Constants.GOOGLE_SAMPLE_RATE) // TODO: Play back the response and find the appropriate value
        audioOutConfig.encoding = .mp3
        audioOutConfig.volumePercentage = volumePercent
        request.config.audioOutConfig = audioOutConfig
        
        do {
            currentCall = try service.converse(completion: { _ in self.Log.debug("Call completed") })
            try currentCall?.send(request) { self.Log.error("Initial send error", $0) }
            try currentCall?.receive(completion: onReceive)
        } catch { Log.error("Initial catch", error, error.localizedDescription) }
    }
    
    func sendAudio(frame data: UnsafePointer<UnsafeMutablePointer<Int16>>, withLength length: Int) {
        var request = ConverseRequest()
        let buffer = UnsafeMutableBufferPointer(start: data[0], count: length) // convert from UnsafePointer to BufferPointer
        let data = Data(buffer: buffer) // Wrap Buffer in Data
        request.audioIn = data
        // Don't call currentCall?.receive() in here. Causes tooManyOperations error
        do { try currentCall?.send(request) { self.Log.error("Frame send error", $0.localizedDescription) } }
        catch { Log.error("Frame catch", error, error.localizedDescription) }
    }
    
    func doneSpeaking() {
        do {
            try currentCall?.closeSend { self.Log.info("Closed send") }
            // Receive all response audio responses
            DispatchQueue.global().async {
                while true {
                    do {
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
    
    private func onReceive(response: ConverseReponse?, error: ClientError?) {
        if let response = response {
            self.followUp = response.result.microphoneMode == .dialogFollowOn
            self.converseState = nil
            converseState = (try? ConverseState(serializedData: response.result.conversationState)) ?? converseState
            if !response.result.spokenRequestText.isEmpty {
                self.delegate.updateRequestText(response.result.spokenRequestText)
            }
            self.delegate.updateResponseText(response.result.spokenResponseText.isEmpty ? "Speaking response..." : response.result.spokenResponseText)
            if response.audioOut.audioData.count > 0 { buf.append(response.audioOut.audioData) }
            if response.eventType == .endOfUtterance { self.delegate.stopListening() }
        }
        if let error = error { Log.error("Initial receive error", error) }
    }
    
    func donePlayingResponse() {
        if followUp {
            delegate.startListening()
            followUp = false
        }
    }
}
