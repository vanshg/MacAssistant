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

class AssistantViewController: NSViewController, ConversationTextDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var gearIcon: NSButton!
    @IBOutlet weak var waveformView: CustomPlot!
    @IBOutlet weak var microphoneButton: NSButton!
    @IBOutlet weak var speakerButton: NSButton!
    @IBOutlet weak var spokenTextLabel: NSTextField!
    
    private let settingsWindow = NSWindowController(windowNibName: "PreferencesWindow")
    
    private var player: AVAudioPlayer?
    
    
    private let googleColors = [NSColor.red, NSColor.blue, NSColor.yellow, NSColor.green]
    private var nativeFormat = AKSettings.audioFormat
    private var colorChangingIndex = 1
    private var conversation = [ConversationEntry]()
    private var mic = AKMicrophone()
    private var desiredFormat = AVAudioFormat(commonFormat: .pcmFormatInt16,
                                              sampleRate: Double(Constants.GOOGLE_SAMPLE_RATE),
                                              channels: 1,
                                              interleaved: true)
    
    private lazy var api: API = API(self)
    private lazy var plot: AKNodeOutputPlot = AKNodeOutputPlot(self.mic, frame: self.waveformView.bounds)
    private lazy var converter: AVAudioConverter = AVAudioConverter(from: self.nativeFormat,
                                                                    to: self.desiredFormat)
    private lazy var outputBuffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: self.desiredFormat,
                                                                       frameCapacity: AVAudioFrameCount(Constants.GOOGLE_SAMPLES_PER_FRAME))
    
    public var isListening: Bool { get { return AudioKit.engine.isRunning } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlot()
        microphoneButton.image?.isTemplate = true
        AudioKit.output = AKBooster(mic, gain: 0)
        AudioKit.engine.inputNode?.installTap(onBus: 0,
                                              bufferSize: UInt32(Constants.NATIVE_SAMPLES_PER_FRAME),
                                              format: nil, block: onTap)
    }
    
    public func onTap(buffer: AVAudioPCMBuffer, _: AVAudioTime) {
        var error: NSError?
        converter.convert(to: outputBuffer, error: &error) { _, inputStatusPtr in
            inputStatusPtr.pointee = .haveData
            return buffer
        }
        
        if let error = error { print("Conversion error \(error)") }
        else if let data = outputBuffer.int16ChannelData {
            self.api.sendAudio(frame: data, withLength: Int(outputBuffer.frameLength))
        }
    }
    
    
    func setupPlot() {
        waveformView.setClickListener(h: buttonAction)
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = googleColors[0]
        plot.backgroundColor = NSColor.clear
        plot.autoresizingMask = .viewWidthSizable
        plot.shouldOptimizeForRealtimePlot = true
        plot.plotType = .buffer
        waveformView.addSubview(plot)
        Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.updatePlotWaveformColor), userInfo: nil, repeats: true)
    }
    
    func updatePlotWaveformColor() {
        plot.color = googleColors[colorChangingIndex]
        colorChangingIndex = (colorChangingIndex + 1) % googleColors.count
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if AudioKit.engine.isRunning {
            stopListening()
        } else if !(player?.isPlaying ?? false) {
            startListening()
        }
    }
    
    func startListening() {
        api.initiateRequest(volumePercent: Int32(mic.volume * 100))
        AudioKit.start()
        let file = Bundle.main.url(forResource: "begin_prompt", withExtension: "mp3")!
        player = try! AVAudioPlayer(contentsOf: file)
        player!.play()
        DispatchQueue.main.async {
            self.microphoneButton.isHidden = true
            self.plot.isHidden = false
            self.speakerButton.isHidden = true
        }
        spokenTextLabel.stringValue = ""
    }
    
    func stopListening() {
        AudioKit.stop()
        api.doneSpeaking()
        DispatchQueue.main.async {
            self.microphoneButton.isHidden = false
            self.plot.isHidden = true
            self.speakerButton.isHidden = true
        }
    }
    
    func playResponse(_ data: Data) {
        do {
            player = try AVAudioPlayer(data: data, fileTypeHint: AVFileTypeMPEGLayer3)
            player?.play()
            player?.delegate = self
            speakerIcon(isShown: true)
        } catch {
            print("Audio out error \(error):\(error.localizedDescription)")
            speakerIcon(isShown: false)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        speakerIcon(isShown: false)
        api.donePlayingResponse()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        speakerIcon(isShown: false)
    }
    
    @IBAction func stopSpeaking(_ sender: NSButton) {
        player?.stop()
        speakerIcon(isShown: false)
    }
    
    func speakerIcon(isShown: Bool) {
        DispatchQueue.main.async {
            self.speakerButton.isHidden = !isShown
            self.microphoneButton.isHidden = isShown
            self.plot.isHidden = true
        }
    }
    
    func updateRequestText(_ text: String) {
        print("Request text: \(text)")
        DispatchQueue.main.async {
            self.spokenTextLabel.stringValue = "\"\(text)\""
        }
//        conversation.append(ConversationEntry(text: text, fromUser: true))
    }
    
    func updateResponseText(_ text: String) {
//        conversation.append(ConversationEntry(text: text, fromUser: false))
    }
    
    @IBAction func gearClicked(_ sender: Any) {
        if let event = NSApp.currentEvent, let menu = gearIcon.menu {
            NSMenu.popUpContextMenu(menu, with: event, for: gearIcon)
        }
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        settingsWindow.showWindow(sender)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        // will perform logout actions via KVO in AppDelegate
        UserDefaults.standard.set(false, forKey: Constants.LOGGED_IN_KEY)
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApp.terminate(self)
    }
}
