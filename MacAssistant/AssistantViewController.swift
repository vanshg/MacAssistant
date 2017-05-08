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

class AssistantViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var waveformView: CustomPlot!
    @IBOutlet weak var microphoneButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    
    let googleColors = [NSColor.red, NSColor.blue, NSColor.yellow, NSColor.green]
    private var colorChangingTimer: Timer?
    private var colorChangingIndex = 1
    private var api = API()
    private var plot: AKNodeOutputPlot?
//    private var audioEngine = AVAudioEngine()
    private var conversation = [ConversationEntry]()
    private var nativeFormat = AKSettings.audioFormat
    private var desiredFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: true)
    private var converter: AVAudioConverter?
    private var outputBuffer: AVAudioPCMBuffer?
    private var mic = AKMicrophone()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFakeData()
        AudioKit.output = AKBooster(mic, gain: 0)
        converter = AVAudioConverter(from: nativeFormat, to: desiredFormat)
        outputBuffer = AVAudioPCMBuffer(pcmFormat: desiredFormat, frameCapacity: 1600) // buffersize of 1600 to get 100 ms of data when converted to 16 kHz
        AudioKit.engine.inputNode?.installTap(onBus: 0, bufferSize: 4410, format: nil, block: onTap)
        setupPlot()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    private func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        let identifier = conversation[row].fromUser ? "righTextCell" : "leftTextCell"
//        print("Identifier: \(identifier)")
//        if let cell = tableView.make(withIdentifier: identifier, owner: self) {
//            return cell
//        }
//        return nil
////        return NSTextFieldCell(textCell: conversation[row].text)
//    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let convo = conversation[row]
        if tableColumn?.identifier == "rightColumn" {
            if convo.fromUser {
                return convo.text
            }
        }
        if tableColumn?.identifier == "leftColumn" {
            if !convo.fromUser {
                return convo.text
            }
        }
        return nil
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return conversation.count
    }
    
    public func onTap(buffer: AVAudioPCMBuffer, _: AVAudioTime) {
        if let _ = buffer.floatChannelData {
            var err: NSError?
            converter?.convert(to: outputBuffer!, error: &err) { packetCount, inputStatusPtr in
                inputStatusPtr.pointee = .haveData
                return buffer
            }
            
            if let error = err {
                print("Conversion error \(error)")
            } else {
                if let data = outputBuffer?.int16ChannelData, let length = outputBuffer?.frameLength {
                    self.api.sendAudio(frame: data, withLength: Int(length))
                }
            }
        }
    }
    
    
    func setupPlot() {
        waveformView.setClickListener(h: buttonAction)
        plot = AKNodeOutputPlot(mic, frame: waveformView.bounds)
        plot?.shouldFill = false
        plot?.shouldMirror = true
        plot?.color = googleColors[0]
        plot?.backgroundColor = NSColor.clear
        plot?.autoresizingMask = .viewWidthSizable
        waveformView.addSubview(plot!)
        colorChangingTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.updatePlotWaveformColor), userInfo: nil, repeats: true);
    }
    
    func updatePlotWaveformColor() {
        plot?.color = googleColors[colorChangingIndex]
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
        AudioKit.start()clear
        
        microphoneButton.isHidden = true
        plot?.isHidden = false
    }
    
    func stopListening() {
        AudioKit.stop()
        api.doneSpeaking()
        microphoneButton.isHidden = false
        plot?.isHidden = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    func loadFakeData() {
        for i in 0...50 {
            conversation.append( ConversationEntry(text: "User \(i)", fromUser: true))
            conversation.append(ConversationEntry(text: "Response \(i)", fromUser: false))
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}


class CustomPlot : EZAudioPlot {

    
    typealias EventHandler = (Any) -> ()
    private var handler: EventHandler?
    
    public func setClickListener(h: @escaping EventHandler) {
        handler = h
    }
    
    override func mouseDown(with event: NSEvent) {
        handler?(event)
    }
}
