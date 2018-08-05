//
//  ConversationItem.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 8/4/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa

class ConversationItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        textField?.stringValue = "Hello"
    }
    
}
