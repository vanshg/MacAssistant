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
import SwiftyUserDefaults

// Eventual TODO: AssistantViewController should only interact with views
// Current Assistant.swift should be renamed to API.swift
// New Assistant.swift should handle business logic of mic/follow up/audio/



class AssistantViewController: NSViewController, AssistantDelegate, AudioDelegate {
    
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
        conversationCollectionView.delegate = self
        conversationCollectionView.register(NSNib(nibNamed: "ConversationItem", bundle: nil), forItemWithIdentifier: conversationItemIdentifier)
    }
    
    override func viewDidAppear() {
        if Defaults[.shouldListenOnMenuClick] {
            onMicClicked()
        }
    }
    
    override func viewDidDisappear() {
        cancelCurrentRequest()
    }

    func onAssistantCallCompleted(result: CallResult) {
        currentAssistantCall = nil
        Log.debug("Assistant Call Completed. Description: \(result.description)")
        
        if !result.success {
            // TODO: show error (Create ErrorConversationEntry)
        }

        if let statusMessage = result.statusMessage {
            Log.debug(statusMessage)
        }
    }
    
    func onDoneListening() {
        Log.debug("Done Listening")
        audioEngine.stopRecording()
        currentAssistantCall?.doneSpeaking = true
    }
    
    // Received text to display
    func onDisplayText(text: String) {
        Log.debug("Received display text: \(text)")
        conversation.append(ConversationEntry(isFromUser: false, text: text))
        conversationCollectionView.reloadBackground()
    }
    
    func onScreenOut(htmlData: String) {
        // TODO: supplementalView to display screen out?
        // TODO: Handle HTML Screen Out data
        Log.info(htmlData)
    }
    
    func onTranscriptUpdate(transcript: String) {
        Log.debug("Transcript update: \(transcript)")
        conversation[conversation.count - 1].text = transcript
        conversationCollectionView.reloadBackground()
    }
    
    func onAudioOut(audio: Data) {
        Log.debug("Got audio")
        audioEngine.playResponse(data: audio) { success in
            if !success {
                self.Log.error("Error playing audio out")
            }
            
            // Regardless of audio error, still follow up
            if self.followUpRequired {
                self.followUpRequired = false
                if self.micWasUsed {
                    self.Log.debug("Following up with mic")
                    self.onMicClicked()
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
    
    func cancelCurrentRequest() {
        followUpRequired = false
        audioEngine.stopPlayingResponse()
        if let call = currentAssistantCall {
            Log.debug("Cancelling current request")
            call.call.cancel()
            if (!call.doneSpeaking) {
                conversation.removeLast()
                conversationCollectionView.reloadBackground()
            }
            currentAssistantCall = nil
            onDoneListening()
        }
    }
}

// UI Actions
extension AssistantViewController {
    @IBAction func onEnterClicked(_ sender: Any) {
        let query = keyboardInputField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isNotEmpty {
            Log.debug("Processing text query: \(query)")
            micWasUsed = false
            conversation.append(ConversationEntry(isFromUser: true, text: query))
            conversationCollectionView.reloadData()
            let lastIndexPath = Set([IndexPath(item: conversation.count-1, section: 0)])
            conversationCollectionView.scrollToItems(at: lastIndexPath, scrollPosition: .bottom)
            assistant.sendTextQuery(text: query, delegate: self)
            keyboardInputField.stringValue = ""
        }
    }
    
    @IBAction func onMicClicked(_ sender: Any? = nil) {
        Log.debug("Mic clicked")
        audioEngine.playBeginPrompt()
        micWasUsed = true
        audioEngine.stopPlayingResponse()
        currentAssistantCall = AssistCallContainer(call: assistant.initiateSpokenRequest(delegate: self))
        audioEngine.startRecording()
        conversation.append(ConversationEntry(isFromUser: true, text: "..."))
        conversationCollectionView.reloadData()
    }
    
    // TODO: Link this up with the Mic Graph (Another TODO: Get the Mic Waveform working)
    func onWaveformClicked(_ sender: Any?) {
        Log.debug("Listening manually stopped")
        audioEngine.stopRecording()
        try? currentAssistantCall?.call.closeSend()
    }
}

// CollectionView related methods
extension AssistantViewController: NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversation.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: conversationItemIdentifier, for: indexPath) as! ConversationItem
        item.loadData(data: conversation[indexPath.item])
        return item
    }
    
    //    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
    //
    //
    //        let myNib = NSNib(nibNamed: "ConversationItem", bundle: nil)!
    //        var myArray: NSArray!
    //        myNib.instantiate(withOwner: ConversationItem.self, topLevelObjects: &myArray) // instantiate view and put in myArray
    //        var item: ConversationItem? = nil
    //        for i in myArray {
    //            if let i = i as? ConversationItem {
    //                item = i
    //            }
    //        }
    ////        let item = myArray[2] as! ConversationItem
    //
    ////        Bundle.main.loadNibNamed("ConversationItem", owner: self, topLevelObjects: &myArray)
    ////        let picker = NSBundle.mainBundle().loadNibNamed("advancedCellView", owner: nil, options: nil)
    ////        let item = myArray[0] as! ConversationItem
    //
    ////        let item = collectionView.makeItem(withIdentifier: conversationItemIdentifier, for: IndexPath(item: 0, section: 0)) as! ConversationItem
    ////        let item = collectionView.item(at: indexPath)
    //        if let item = item as ConversationItem? {
    //            item.loadData(data: conversation[indexPath.item])
    //            let width = item.textField!.frame.size.width
    //            let newSize = item.textField!.sizeThatFits(NSSize(width: width, height: .greatestFiniteMagnitude))
    //            item.textField?.frame.size = NSSize(width: 300, height: newSize.height)
    //            print(item.textField!.frame.size)
    //            return item.textField!.frame.size
    //        }
    //
    //        print("here 2")
    //        return NSSize(width: 300, height: 30)
    //
    //    }
}
