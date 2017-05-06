//
//  ConversationEntry.swift
//  MacAssistant
//
//  Created by Vansh on 5/5/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Foundation

class ConversationEntry {
    var text: String
    var fromUser: Bool
    
    init(text: String, fromUser: Bool) {
        self.text = text
        self.fromUser = fromUser
    }
}
