//
//  ConversationTextDelegate.swift
//  MacAssistant
//
//  Created by Vansh on 5/8/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Foundation

protocol ConversationTextDelegate {
    func updateRequestText(_: String)
    func updateResponseText(_: String)
    func stopListening()
    func startListening()
    func playResponse(_: Data)
}
