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
    var isLoggedIn: DefaultsKey<Bool> { .init("isLoggedIn", defaultValue: false) }
    var accessToken: DefaultsKey<String?> { .init("accessToken") }
    var refreshToken: DefaultsKey<String?> { .init("refreshToken") }
    var tokenExpirationDate: DefaultsKey<Date?> { .init("tokenExpirationDate") }
    var conversationState: DefaultsKey<Data?> { .init("conversationState") }
}
