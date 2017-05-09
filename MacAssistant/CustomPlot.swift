//
//  CustomPlot.swift
//  MacAssistant
//
//  Created by Vansh on 5/8/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import AudioKit

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
