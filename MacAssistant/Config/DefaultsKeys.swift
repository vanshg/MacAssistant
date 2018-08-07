//
//  DefaultsExtension.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 7/30/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let isLoggedIn = DefaultsKey<Bool>("isLoggedIn")
    static let accessToken = DefaultsKey<String>("accessToken")
    static let refreshToken = DefaultsKey<String>("refreshToken")
    static let tokenExpirationDate = DefaultsKey<Date?>("tokenExpirationDate")
    static let conversationState = DefaultsKey<Data>("conversationState")

}
