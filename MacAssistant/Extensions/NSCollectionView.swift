//
//  NSCollectionView.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 10/31/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa

extension NSCollectionView {
    public func reloadBackground() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
