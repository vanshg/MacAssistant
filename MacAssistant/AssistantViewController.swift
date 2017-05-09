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

class AssistantViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, ConversationTextDelegate {
    
    @IBOutlet weak var waveformView: CustomPlot!
    @IBOutlet weak var microphoneButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFakeData()
        setupPlot()
        tableView.delegate = self
        tableView.dataSource = self
        AudioKit.output = AKBooster(mic, gain: 0)
        AudioKit.engine.inputNode?.installTap(onBus: 0,
                                              bufferSize: UInt32(Constants.NATIVE_SAMPLES_PER_FRAME),
                                              format: nil, block: onTap)
    }
    
    private func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        let convo = conversation[row]
        let cell = NSTextFieldCell(textCell: convo.text)
        cell.alignment = convo.fromUser ? .right : .left
        cell.textColor = NSColor.white
        print("configuring")
        return cell
    }
    
    
    
    // TODO
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        return conversation[row].text
//        let convo = conversation[row]
//        if tableColumn?.identifier == "rightColumn" {
//            if convo.fromUser {
//                return convo.text
//            }
//        }
//        if tableColumn?.identifier == "leftColumn" {
//            if !convo.fromUser {
//                return convo.text
//            }
//        }
//        return nil
//    }
    
    func numberOfRows(in tableView: NSTableView) -> Int { return conversation.count }
    
    public func onTap(buffer: AVAudioPCMBuffer, _: AVAudioTime) {
        if let _ = buffer.floatChannelData {
            var err: NSError?
            converter.convert(to: outputBuffer, error: &err) { packetCount, inputStatusPtr in
                inputStatusPtr.pointee = .haveData
                return buffer
            }
            
            if let error = err {
                print("Conversion error \(error)")
            } else {
                if let data = outputBuffer.int16ChannelData {
                    self.api.sendAudio(frame: data, withLength: Int(outputBuffer.frameLength))
                }
            }
        }
    }
    
    
    func setupPlot() {
        waveformView.setClickListener(h: buttonAction)
        plot.shouldFill = false
        plot.shouldMirror = true
        plot.color = googleColors[0]
        plot.backgroundColor = NSColor.clear
        plot.autoresizingMask = .viewWidthSizable
        waveformView.addSubview(plot)
        Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.updatePlotWaveformColor), userInfo: nil, repeats: true);
    }
    
    func updatePlotWaveformColor() {
        plot.color = googleColors[colorChangingIndex]
        colorChangingIndex = (colorChangingIndex + 1) % googleColors.count
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if AudioKit.engine.isRunning {
            stopListening()
        } else {
            startListening()
        }
    }
    
    func startListening() {
        api.initiateRequest()
        AudioKit.start()
        DispatchQueue.main.async {
            self.microphoneButton.isHidden = true
            self.plot.isHidden = false
        }
    }
    
    func stopListening() {
        AudioKit.stop()
        api.doneSpeaking()
        DispatchQueue.main.async {
            self.microphoneButton.isHidden = false
            self.plot.isHidden = true
        }
    }
    
    // TODO
    func playResponse(_ data: Data) {
//        do {
//            let player = try AVAudioPlayer(data: data)
//            player.play()
//        } catch { print("Audio out error \(error):\(error.localizedDescription)") }
    }
    
    func loadFakeData() {
        for i in 0...10 {
            conversation.append(ConversationEntry(text: "User \(i)", fromUser: true))
            conversation.append(ConversationEntry(text: "Response \(i)", fromUser: false))
        }
    }
    
    func updateRequestText(_ text: String) {
        conversation.append(ConversationEntry(text: text, fromUser: true))
        tableView.reloadData()
    }
    
    func updateResponseText(_ text: String) {
        conversation.append(ConversationEntry(text: text, fromUser: false))
        tableView.reloadData()
    }
    
    @IBAction func gearClicked(_ sender: Any) {
        
    }
    
    @IBAction func actionClicked(_ sender: Any) {
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        
    }
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApp.terminate(self)
    }
}
