//
// Created by Vansh Gandhi on 7/26/18.
// Copyright (c) 2018 Vansh Gandhi. All rights reserved.
//

import Foundation
import AudioKit
import Log

typealias AudioPlayerHandler = (Bool) -> Void

public class AudioEngine: NSObject, AVAudioPlayerDelegate {

    let Log = Logger()
    let sampleRate = Double(AudioConstants.GOOGLE_SAMPLE_RATE)
    lazy var sampleRateRatio = AKSettings.sampleRate / sampleRate
    lazy var desiredFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: self.sampleRate, channels: 1, interleaved: false)!
    lazy var converter = AVAudioConverter(from: AudioKit.format, to: desiredFormat)!
    lazy var mic = AKMicrophone()
    var delegate: AudioDelegate!
    var responsePlayer: AVAudioPlayer?
    var beginPromptPlayer: AVAudioPlayer! // Played when you start recording
    var confirmationPromptPlayer: AVAudioPlayer! // Played when Google responds with endOfUtterance
    var cancelPromptPlayer: AVAudioPlayer! // Played when user cancels request
    var isRecording: Bool {
        get {
            return mic.isStarted
        }
    }
    var responseFinishedPlayingHandler: AudioPlayerHandler? = nil

    public init(delegate: AudioDelegate) {
        super.init()
        self.delegate = delegate
        AKSettings.sampleRate = AudioConstants.NATIVE_SAMPLE_RATE
        AudioKit.output = AKBooster(mic, gain: 0)
        mic.avAudioNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(AudioConstants.NATIVE_SAMPLES_PER_FRAME), format: nil, block: onTap)
        try! AudioKit.start()
        
        // Setup prompts
//        let beginPromptUrl = Bundle.main.url(forResource: "begin_prompt", withExtension: "mp3", subdirectory: "Audio")!
//        beginPromptPlayer = try! AVAudioPlayer(contentsOf: beginPromptUrl)
        
//        let confirmationPromptUrl = Bundle.main.url(forResource: "confirmation_prompt", withExtension: "mp3", subdirectory: "Audio")!
//        confirmationPromptPlayer = try! AVAudioPlayer(contentsOf: confirmationPromptUrl)
        
//        let cancelPromptUrl = Bundle.main.url(forResource: "cancel_prompt", withExtension: "mp3", subdirectory: "Audio")!
//        cancelPromptPlayer = try! AVAudioPlayer(contentsOf: cancelPromptUrl)
    }

    func onTap(buffer: AVAudioPCMBuffer, time: AVAudioTime) {
        let capacity = Int(Double(buffer.frameCapacity) / sampleRateRatio)
        let bufferPCM16 = AVAudioPCMBuffer(pcmFormat: self.desiredFormat, frameCapacity: AVAudioFrameCount(capacity))!

        var error: NSError? = nil
        self.converter.convert(to: bufferPCM16, error: &error) { inNumPackets, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }

        if let error = error {
            self.Log.error(error)
            return
        }

        let channel = UnsafeBufferPointer(start: bufferPCM16.int16ChannelData!, count: 1)
        let data = Data(bytes: channel[0], count: capacity * 2)
        delegate.onMicrophoneInputAudio(audioData: data)
    }


    public func playResponse(data: Data, completionHandler: @escaping (Bool) -> Void) {
        responsePlayer?.delegate = nil // Resets any old delegates that were set for previous audio plays
        responseFinishedPlayingHandler = completionHandler
        responsePlayer = try? AVAudioPlayer(data: data, fileTypeHint: AVFileType.mp3.rawValue)
        responsePlayer?.delegate = self
        responsePlayer?.play()
    }
    
    public func stopPlayingResponse() {
        if (responsePlayer?.isPlaying ?? false) {
            responsePlayer?.stop()
        }
    }

    public func startRecording() {
        Log.debug("Start recording")
        mic.start()
    }

    public func stopRecording() {
        Log.debug("Stop recording")
        mic.stop()
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        responseFinishedPlayingHandler?(flag)
    }
    
    public func playBeginPrompt() {
//        beginPromptPlayer.play()
    }
    
    public func playConfirmationPrompt() {
//        confirmationPromptPlayer.play()
    }
    
    public func playCancelledPrompt() {
//        cancelPromptPlayer.play()
    }
    
}
