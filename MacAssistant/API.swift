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

class API {
    
    let ASSISTANT_API_ENDPOINT = "embeddedassistant.googleapis.com"
    var service: Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantService?
    var currentCall: Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantConverseCall?
    
    public init() {
        service = Google_Assistant_Embedded_V1Alpha1_EmbeddedAssistantService(address: ASSISTANT_API_ENDPOINT)
        let token = "Bearer \(UserDefaults.standard.string(forKey: Constants.AUTH_TOKEN_KEY)!)"
        service?.metadata = Metadata(["authorization" : token])
    }
    
    func initiateRequest() {
        var request = Google_Assistant_Embedded_V1alpha1_ConverseRequest()
        request.config = Google_Assistant_Embedded_V1alpha1_ConverseConfig()
        var audioInConfig = Google_Assistant_Embedded_V1alpha1_AudioInConfig()
        audioInConfig.sampleRateHertz = 16000 //TODO: This needs to change
        audioInConfig.encoding = .linear16
        request.config.audioInConfig = audioInConfig
        do {
            currentCall = try service?.converse(completion: { result in
                print("Result code \(result.statusCode)")
                print("Result description \(result.description)")
                print("Metadat \(String(describing: result.initialMetadata))")
                print("Status message \(result.statusMessage!)")
                print("Obj description \(String(describing: result))")
            })
        } catch {
            print("Initial error \(error)")
        }
    }
    
    func sendAudioFrame(data: UnsafePointer<UnsafeMutablePointer<Int16>>, length: Int) {
        var request = Google_Assistant_Embedded_V1alpha1_ConverseRequest()
        var byteData = [UInt8]()
        let unwrapped = data[0]
        for i in 0...length {
            let uNv = UInt16(bitPattern: unwrapped[i])
            byteData.append(UInt8(uNv >> 8))
            byteData.append(UInt8(uNv & 0x00ff))
        }
        request.audioIn = Data(byteData)
        do {
            try currentCall?.send(request, errorHandler: { err in
                print("Error \(err.localizedDescription)")
            })
        } catch {
            print("Error is \(error.localizedDescription)")
        }
    }
}
