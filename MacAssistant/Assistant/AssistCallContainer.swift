//
//  AssistCallContainer.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 10/31/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

class AssistCallContainer {
    let call: AssistCall!
    var doneSpeaking = false
    
    public init(call: AssistCall!) {
        self.call = call
    }
}
