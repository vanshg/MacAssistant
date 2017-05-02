//
//  AssistantViewController.swift
//  MacAssistant
//
//  Created by Vansh on 4/27/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Cocoa
import AudioKit
import AVFoundation

class AssistantViewController: NSViewController {
    
    @IBOutlet weak var waveformView: EZAP!
    @IBOutlet weak var microphoneButton: NSButton!
    
    let googleColors = [NSColor.red, NSColor.blue, NSColor.yellow, NSColor.green]
    private var colorChangingTimer: Timer?
    private var colorChangingIndex = 1
    private var mic: AKMicrophone!
    private var test: AKNode!
    private var silence: AKBooster!
    private var api = API()
    private var plot: AKNodeOutputPlot?
    private var audioEngine = AVAudioEngine()
//    private var recorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var format = audioEngine.inputNode.inputFormat(forBus: 0)
//        print("Sample rate \(format.sampleRate)")
//        format.
//        AudioKit.format = format
//        AKSettings.enableLogging = true
//        AKSettings.audioInputEnabled = true
//        mic = AKMicrophone()
//        test = AKMixer(mic)
//        AKSettings.sampleRate = 16000
//        AKSettings.recordingBufferLength = .short
//        let tempFile = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp")
//        print("file is \(String(describing: tempFile?.absoluteString))")
//        recorder = try! AVAudioRecorder(url: tempFile!, format: format)
//        recorder?.prepareToRecord()
        
        
        
        
        
        
        
        
//        let downMixer = AVAudioMixerNode()
//        audioEngine.attach(downMixer)
        let desiredFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: true)
        let nativeFormat = audioEngine.inputNode?.inputFormat(forBus: 0)
        let converter = AVAudioConverter(from: nativeFormat!, to: desiredFormat)
        audioEngine.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, when in //AVAudioPCMBuffer, AVAudioTime
            if buffer.int16ChannelData != nil {
                print("int16 is not nil! :)")
            }

            if buffer.floatChannelData != nil {
                let outputBuffer = AVAudioPCMBuffer.init(pcmFormat: desiredFormat, frameCapacity: buffer.frameCapacity)
                outputBuffer.frameLength = buffer.frameLength
                try! converter.convert(to: outputBuffer, from: buffer)
                if outputBuffer.int16ChannelData != nil {
                    print("conversion successful")
                }
                self.api.sendAudioFrame(data: outputBuffer.int16ChannelData!, length: Int(outputBuffer.frameLength))
                print("float is not nil :(")
            }
        }
        audioEngine.connect(audioEngine.inputNode!, to: audioEngine.mainMixerNode, format: nil)
        audioEngine.prepare()



//        AVCaptureAudioDataOutput()
        
//        test.avAudioNode.installTap(onBus: 0, bufferSize: 1024, format: nativeFormat) { buffer, when in //AVAudioPCMBuffer, AVAudioTime
//            print("Sample rate: \(when.sampleRate)")
//            print("Frame length: \(buffer.frameLength)")
//            print("Frame capacity: \(buffer.frameCapacity)")
//            if let data = buffer.int16ChannelData {
//                print("Was not nil")
//                self.api.sendAudioFrame(data: data, length: Int(buffer.frameLength))
//            }
//
//            if buffer.floatChannelData != nil {
////                let tempBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: buffer.frameCapacity)
////                try! converter.convert(to: tempBuffer, from: buffer)
////                self.api.sendAudioFrame(data: tempBuffer.int16ChannelData!, length: Int(tempBuffer.frameLength))
//                print("float not nil")
//            }
//        }
        
        
        
//        waveformView.setClickListener {
//            print("executing")
//            AudioKit.stop()
//            self.waveformView.isHidden = true
//            self.microphoneButton.isHidden = false;
//        }
    }
    
    func printDebugInfo() {
        print("Sample rate is \(AKSettings.sampleRate)")
        print("Audio format description is \(AKSettings.audioFormat.commonFormat.description)")
        print("Audio format sample rate is \(AKSettings.audioFormat.sampleRate)")
        print("Buffer length is \(AKSettings.bufferLength.rawValue)")
        print("Rec buffer length is \(AKSettings.recordingBufferLength.rawValue)")
        print("Num channels is \(AKSettings.numberOfChannels)")
    }
    
    
    func setupPlot() {
        plot = AKNodeOutputPlot(test, frame: waveformView.bounds)
        plot?.shouldFill = false
        plot?.shouldMirror = true
        plot?.color = googleColors[0]
        plot?.backgroundColor = NSColor(calibratedWhite: 0, alpha: 0) // Transparent
        plot?.autoresizingMask = .viewWidthSizable
        waveformView.addSubview(plot!)
        colorChangingTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.updatePlotWaveformColor), userInfo: nil, repeats: true);
    }
    
    func updatePlotWaveformColor() {
        plot?.color = googleColors[colorChangingIndex]
        colorChangingIndex = (colorChangingIndex + 1) % googleColors.count
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
        } else {
            api.initiateRequest()
            try! audioEngine.start()
        }
//        if (recorder?.isRecording)! {
//            recorder?.stop()
//        } else {
//            recorder?.record(forDuration: 10)
//        }
//        if (AudioKit.engine.isRunning) {
//            AudioKit.stop()
//
//        } else {
//            api.initiateRequest()
//            AudioKit.start()
//        }
//        waveformView.isHidden = false
//        microphoneButton.isHidden = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
//        AudioKit.output = silence
        setupPlot()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}


class EZAP : EZAudioPlot {

    
    typealias EventHandler = (Void) -> ()
    private var handler: EventHandler?
    
    public func setClickListener(h: @escaping EventHandler) {
        handler = h
    }
    
    override func mouseDown(with event: NSEvent) {
        handler?()
    }
}
