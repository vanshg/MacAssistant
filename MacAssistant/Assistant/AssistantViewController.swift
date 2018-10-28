//
//  AssistantViewController.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 8/3/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa
import Log
import SwiftGRPC
import WebKit

class AssistantViewController: NSViewController, AssistantDelegate, AudioDelegate, NSCollectionViewDataSource {
    
    let Log = Logger()
    let assistant = Assistant()
    var conversation: [ConversationEntry] = []
    var currentAssistantCall: AssistCallContainer?
    var followUpRequired = false
    var micWasUsed = false
    lazy var audioEngine = AudioEngine(delegate: self)
    let conversationItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ConversationItem")


    @IBOutlet weak var initialPromptLabel: NSTextField!
    @IBOutlet weak var conversationCollectionView: NSCollectionView!
    @IBOutlet weak var keyboardInputField: NSTextField!
    
    override func viewDidLoad() {
        conversationCollectionView.dataSource = self
        let conversationItemNib = NSNib(nibNamed: "ConversationItem", bundle: nil)
        conversationCollectionView.register(conversationItemNib, forItemWithIdentifier: conversationItemIdentifier)
    }

    @IBAction func onEnterClicked(_ sender: Any) {
        let query = keyboardInputField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isNotEmpty {
            micWasUsed = false
            conversation.append(ConversationEntry(isFromUser: true, text: query))
            conversationCollectionView.reloadData()
            assistant.sendTextQuery(text: query, delegate: self)
            keyboardInputField.stringValue = ""
        }
    }
    
    @IBAction func onMicClicked(_ sender: Any?) {
        micWasUsed = true
        audioEngine.stopPlayingAudio()
        currentAssistantCall = AssistCallContainer(call: assistant.initiateSpokenRequest(delegate: self))
        audioEngine.startRecording()
        conversation.append(ConversationEntry(isFromUser: true, text: "..."))
        conversationCollectionView.reloadData()
    }
    
    // TODO: Link this up with the Mic Graph (Another TODO: Get the Mic Waveform working)
    func onWaveformClicked(_ sender: Any?) {
        audioEngine.stopRecording()
        // TODO: Does a message need to be sent to Google to indicate user has clicked stop recording button?
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversation.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let entry = conversation[indexPath.item]
        let alignment = entry.isFromUser ? NSTextAlignment.right : NSTextAlignment.left
        let item = collectionView.makeItem(withIdentifier: conversationItemIdentifier, for: indexPath)
        item.textField?.stringValue = entry.text
        item.textField?.alignment = alignment
        return item
    }

    // TODO: supplementalView to display screen out?

    func onAssistantCallCompleted(result: CallResult) {
        currentAssistantCall = nil
        
        if !result.success {
            // TODO: show error (Create ErrorConversationEntry)
        }
        
        Log.debug(result.description)
        if let statusMessage = result.statusMessage {
            Log.debug(statusMessage)
        }
    }
    
    func onDoneListening() {
        audioEngine.stopRecording()
        currentAssistantCall?.doneSpeaking = true
        // TODO: Set currentStreamCall to nil?
    }
    
    // Received text to display
    func onDisplayText(text: String) {
        conversation.append(ConversationEntry(isFromUser: false, text: text))
        conversationCollectionView.reloadData()
    }
    
    func onScreenOut(htmlData: String) {
        // TODO: Handle HTML Screen Out data
    }
    
    func onTranscriptUpdate(transcript: String) {
        Log.debug("Transcript update: \(transcript)")
        conversation[conversation.count - 1].text = transcript
        conversationCollectionView.reloadData()
    }
    
    func onAudioOut(audio: Data) {
        Log.debug("Got audio")
        audioEngine.playAudio(data: audio) { success in
            if !success {
                self.Log.error("Error playing audio out")
            }
            
            // Regardless of audio error, still follow up
            if self.followUpRequired {
                if self.micWasUsed {
                    self.onMicClicked(nil)
                } // else, use text input
            }
        }
    }
    
    func onFollowUpRequired() {
        Log.debug("Follow up needed")
        followUpRequired = true // Will follow up after completion of audio out
    }
    
    func onError(error: Error) {
        Log.error("Got error \(error.localizedDescription)")
    }
    
    // Called from AudioEngine (delegate method)
    func onMicrophoneInputAudio(audioData: Data) {
        if let call = currentAssistantCall {
            // We don't want to continue sending data to servers once endOfUtterance has been received
            if !call.doneSpeaking {
                assistant.sendAudioChunk(streamCall: call.call, audio: audioData, delegate: self)
            }
        }
    }
}

class AssistCallContainer {
    let call: AssistCall!
    var doneSpeaking = false
    
    public init(call: AssistCall!) {
        self.call = call
    }
}
