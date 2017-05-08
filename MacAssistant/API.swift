//
//  rpcBindings.swift
//  MacAssistant
//
//  Created by Vansh on 4/28/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Foundation
import AudioKit
import gRPC
import SwiftProtobuf
import Alamofire

typealias AssistantService = Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantService
typealias AssistantCall = Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantConverseCall
typealias AudioInConfig = Google_Assistant_Embedded_V1alpha1_AudioInConfig
typealias AudioOutConfig = Google_Assistant_Embedded_V1alpha1_AudioOutConfig
typealias ConverseRequest = Google_Assistant_Embedded_V1alpha1_ConverseRequest
typealias ConverseConfig = Google_Assistant_Embedded_V1alpha1_ConverseConfig
typealias ConverseReponse = Google_Assistant_Embedded_V1alpha1_ConverseResponse
typealias ClientError = Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantClientError

class API {
    
    var service: AssistantService?
    var currentCall: AssistantCall?
    
    public init() {
        let u = Bundle.main.url(forResource: "roots", withExtension: "pem")!
        let certificate = try! String(contentsOf: u)
        let token = "Bearer \(UserDefaults.standard.string(forKey: Constants.AUTH_TOKEN_KEY)!)"
        service = AssistantService(address: Constants.ASSISTANT_API_ENDPOINT, certificates: certificate, host: nil)
        service?.metadata = Metadata(["authorization" : token])
    }
    
    func initiateRequest() {
        var request =   ConverseRequest()
        request.config = ConverseConfig()
        
        var audioInConfig = AudioInConfig()
        audioInConfig.sampleRateHertz = 16000 //TODO: This needs to change
        audioInConfig.encoding = .linear16
        request.config.audioInConfig = audioInConfig
        
        
        var audioOutConfig = AudioOutConfig()
        audioOutConfig.sampleRateHertz = 16000
        audioOutConfig.encoding = .linear16
        audioOutConfig.volumePercentage = 50
        request.config.audioOutConfig = audioOutConfig
        
        do {
            currentCall = try service?.converse(completion: { result in
                print("--------------------------------")
                print("Result code \(result.statusCode)")
                print("Result description \(result.description)")
                print("Metadata \(String(describing: result.initialMetadata))")
                print("Status message \(result.statusMessage ?? "no status msg")")
                print("Obj description \(String(describing: result))")
                print("Converse result: \(result)")
                print("--------------------------------")
                
            })
            
            try currentCall?.send(request) { err in
                print("Initial send error: \(err)")
            }

//            try currentCall?.receive() { res, err in
//                if let result = res {
//                    print("Initial receive event: \(result.eventType)")
//                }
//                if let error = err {
//                    print("Initial receive error: \(error)")
//                }
//            }
            
        } catch {
            print("Initial catch: \(error):\(error.localizedDescription)")
        }
    }
    
    func sendAudio(frame data: UnsafePointer<UnsafeMutablePointer<Int16>>, withLength length: Int) {
        var request = ConverseRequest()
        let u = UnsafeMutableBufferPointer(start: data[0], count: length) // convert
        let d = Data(buffer: u)
        request.audioIn = d
        do {
            try currentCall?.send(request) { err in
                print("Frame send error: \(err.localizedDescription)")
            }
            // Don't do currentCall?.receive() in here. Causes tooManyOperations error
        } catch {
            print("Frame catch: \(error):\(error.localizedDescription)")
        }
    }
    
    func doneSpeaking() {
        do {
            try currentCall?.closeSend {
                print("Closed send")
            }
            
            try currentCall?.receive() { res, err in
                if let result = res {
//                    print("Close receive result: \(result)")
//                    print("Close receive result result: \(result.result)")
                    print("++++++++++++++++++++++++++++++")
                    print("Close receive result error: \(result.error.code)")
                    print("Close receive result result mic: \(result.result.microphoneMode)")
                    print("Close receive result result responseText: \(result.result.spokenResponseText)")
                    print("Close receive result result requestText: \(result.result.spokenRequestText)")
                    print("++++++++++++++++++++++++++++++")
                }
                
                if let error = err {
                    print("Close receive error: \(error)")
                }
            }
        } catch {
            print("Close catch: \(error):\(error.localizedDescription)")
        }
    }
}
