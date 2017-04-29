//
//  AssistantViewController.swift
//  MacAssistant
//
//  Created by Vansh on 4/27/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Cocoa
import AudioKit

class AssistantViewController: NSViewController {
    
    @IBOutlet weak var waveformView: EZAP!
    @IBOutlet weak var microphoneButton: NSButton!
    
    let googleColors = [NSColor.red, NSColor.blue, NSColor.yellow, NSColor.green]
    private var colorChangingTimer: Timer?
    private var colorChangingIndex = 1
    private var mic: AKMicrophone!
    private var silence: AKBooster!
    private var api: API!
    private var plot: AKNodeOutputPlot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = API()
        AKSettings.enableLogging = true
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
//        var test = AKMixer(mic)
//        AKSettings.sampleRate = 16000
        AKSettings.recordingBufferLength = .short
        
//        mic.avAudioNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, when in //AVAudioPCMBuffer, AVAudioTime
//            print("Sample rate: \(when.sampleRate)")
//            print("Frame length: \(buffer.frameLength)")
//            print("Frame capacity: \(buffer.frameCapacity)")
//            API.sendAudioFrame(data: buffer.int16ChannelData?[0], length: Int(buffer.frameLength))
//        }
        
        
        
//        waveformView.setClickListener {
//            print("executing")
//            AudioKit.stop()
//            self.waveformView.isHidden = true
//            self.microphoneButton.isHidden = false;
//        }
        // Do any additional setup after loading the view.
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
        plot = AKNodeOutputPlot(mic, frame: waveformView.bounds)
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
        print("Button Action")
        if (AudioKit.engine.isRunning) {
            AudioKit.stop()
            
        } else {
            print("String AudioKit")
            API.initiateRequest()
            AudioKit.start()
            printDebugInfo()
        }
//        waveformView.isHidden = false
//        microphoneButton.isHidden = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        AudioKit.output = mic
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
