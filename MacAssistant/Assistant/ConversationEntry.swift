//
//  ConversationEntry.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 8/4/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Foundation

class ConversationEntry {
    var isFromUser: Bool
    var text: String
    
    init(isFromUser: Bool, text: String) {
        self.isFromUser = isFromUser
        self.text = text
    }
}
