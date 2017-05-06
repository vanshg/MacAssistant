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
//        let u = Bundle.main.url(forResource: "roots", withExtension: "pem")!
//        service = AssistantService(address: Constants.ASSISTANT_API_ENDPOINT, certificates: try! String(contentsOf: u), host: "")
        service = AssistantService(address: Constants.ASSISTANT_API_ENDPOINT)
        let token = "Bearer \(UserDefaults.standard.string(forKey: Constants.AUTH_TOKEN_KEY)!)"
        service?.metadata = Metadata(["authorization" : token])
    }
    
    func initiateRequest() {
        var request =   ConverseRequest()
        request.config = ConverseConfig()
        
        var audioInConfig = AudioInConfig()
        audioInConfig.sampleRateHertz = 44100 //TODO: This needs to change
        audioInConfig.encoding = .linear16
        request.config.audioInConfig = audioInConfig
        
        
        var audioOutConfig = AudioOutConfig()
        audioOutConfig.sampleRateHertz = 16000
        audioOutConfig.encoding = .linear16
        audioOutConfig.volumePercentage = 50
        request.config.audioOutConfig = audioOutConfig
        
        do {
            currentCall = try service?.converse(completion: { result in
                print("Result code \(result.statusCode)")
                print("Result description \(result.description)")
                print("Metadata \(String(describing: result.initialMetadata))")
                print("Status message \(result.statusMessage ?? "Error")")
                print("Obj description \(String(describing: result))")
                print("result \(result)")
            })
            
            try currentCall?.send(request) { err in
                print("Error in initial request: \(err)")
            }
            
            try currentCall?.receive() { result, error in
                print("Event type is \(result?.eventType)")
                print("Error is \(error)")
            }
            
        } catch {
            print("Initial error \(error)")
        }
    }
    
    func sendAudioFrame(data: UnsafePointer<UnsafeMutablePointer<Int16>>, length: Int) {
        var request = ConverseRequest()
        let u = UnsafeMutableBufferPointer(start: data[0], count: length)
        let d = Data(buffer: u)
        print("num bytes: \(d.count)")
        request.audioIn = d
        do {
            try currentCall?.send(request) { err in
                print("Error send \(err.localizedDescription)")
            }
            
//            try currentCall?.receive() { res, err in
//                if let result = res {
//                    print("Got result \(result)")
//                }
//                
//                if let error = err {
//                    print("Error receiver: \(error.localizedDescription)")
//                }
//            }
            
            
        } catch {
            print("Error do \(error):\(error.localizedDescription)")
        }
    }
    
    func doneSpeaking() {
        print("done speaking")
        do {
            try currentCall?.closeSend {
                print("Closed sending connection")
            }
            
            try currentCall?.receive() { res, err in
                if let result = res {
                    print("Got result \(result)")
                }
                
                if let error = err {
                    print("Got error \(error)")
                }
            }
        } catch {
            print("doneSpeaking error \(error.localizedDescription)")
        }
    }
}
