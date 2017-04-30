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

class API {
    
    let ASSISTANT_API_ENDPOINT = "embeddedassistant.googleapis.com"
    
    func test() {
        let c = Channel(address: ASSISTANT_API_ENDPOINT)
    }
    
    static func initiateRequest() {
        var request = Google_Assistant_Embedded_V1alpha1_ConverseRequest()
        request.config = Google_Assistant_Embedded_V1alpha1_ConverseConfig()
        var audioInConfig = Google_Assistant_Embedded_V1alpha1_AudioInConfig()
        audioInConfig.sampleRateHertz = Int32(AKSettings.sampleRate)
        audioInConfig.encoding = .linear16
        request.config.audioInConfig = audioInConfig
        _ = try! request.serializedData()
//        do {
//        } catch BinaryEncodingError.anyTranscodeFailure {
//            print("anyTranscodeFailure")
//        } catch BinaryEncodingError.missingRequiredFields {
//            print("missingRequiredFields")
//        }
    }
    
    static func sendAudioFrame(data: UnsafeMutablePointer<Int16>?, length: Int) {
        var request = Google_Assistant_Embedded_V1alpha1_ConverseRequest()
        var byteData = [UInt8]()
        for i in 0...length {
            let uNv = UInt16(bitPattern: (data?[i])!)
            byteData.append(UInt8(uNv >> 8))
            byteData.append(UInt8(uNv & 0x00ff))
        }
        request.audioIn = Data(byteData)
    }
}
