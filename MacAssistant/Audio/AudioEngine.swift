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
    let mic = AKMicrophone()
    var delegate: AudioDelegate!
    var player: AVAudioPlayer?
    var isRecording: Bool {
        get {
            return AudioKit.engine.isRunning
        }
    }
    var audioFinishedPlayingHandler: AudioPlayerHandler? = nil

    public init(delegate: AudioDelegate) {
        super.init()
        self.delegate = delegate
//        AudioKit.output = AKBooster(mic, gain: 0)
        AudioKit.output = AKMixer()
        mic.avAudioNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(AudioConstants.NATIVE_SAMPLES_PER_FRAME), format: nil, block: onTap)
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


    public func playAudio(data: Data, completionHandler: @escaping (Bool) -> Void) {
        player?.delegate = nil // Resets any old delegates that were set for previous audio plays
        audioFinishedPlayingHandler = completionHandler
        player = try? AVAudioPlayer(data: data, fileTypeHint: AVFileType.mp3.rawValue)
        player?.delegate = self
        player?.play()
    }
    
    public func stopPlayingAudio() {
        if (player?.isPlaying ?? false) {
            player?.stop()
        }
    }

    public func startRecording() {
        Log.debug("Start recording")
        try? AudioKit.start()
    }

    public func stopRecording() {
        Log.debug("Stop recording")
        try? AudioKit.stop()
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioFinishedPlayingHandler?(flag)
    }

}
