//
// Created by Vansh Gandhi on 7/26/18.
// Copyright (c) 2018 Vansh Gandhi. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import SwiftyJSON
import Log
import SwiftyUserDefaults

public class Authenticator {

    static let instance = Authenticator(scope: "https://www.googleapis.com/auth/assistant-sdk-prototype")

    let Log = Logger()
    var scope: String
    var authUrl: String
    var tokenUrl: String
    var redirectUrl: String
    var clientId: String
    var clientSecret: String
    var loginUrl: String

    init(scope: String) {
        self.scope = scope
        let url = Bundle.main.url(forResource: "google_oauth", withExtension: "json")!
        let json = try! JSON(data: Data(contentsOf: url))["installed"]
        authUrl = json["auth_uri"].stringValue
        tokenUrl = json["token_uri"].stringValue
        redirectUrl = json["redirect_uris"][1].stringValue // Get the "http://localhost" url
        clientId = json["client_id"].stringValue
        clientSecret = json["client_secret"].stringValue
        loginUrl = "\(authUrl)?client_id=\(clientId)&scope=\(scope)&response_type=code&redirect_uri=\(redirectUrl)"

        Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
            // First run is at time 0 (aka, when the app first starts up)
            if Defaults[.isLoggedIn] {
                self.refreshTokenIfNecessary()
            }
        }.fire()
    }

    func authenticate(code: String, onLoginResult: @escaping (Error?) -> Void) {
        let parameters = [
            "code": code,
            "client_id": clientId,
            "client_secret": clientSecret,
            "redirect_uri": redirectUrl,
            "grant_type": "authorization_code",
        ]

        Alamofire.request(tokenUrl, method: .post, parameters: parameters).responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let err = json["error"].string {
                    self.Log.debug("\(err): \(json["error_description"].string ?? "no error msg")")
                    onLoginResult(NSError())
                    return
                }
                
                let tokenExpiration = Date(timeInterval: TimeInterval(json["expires_in"].intValue), since: Date())
                Defaults[.tokenExpirationDate] = tokenExpiration
                Defaults[.accessToken] = json["access_token"].stringValue
                Defaults[.refreshToken] = json["refresh_token"].stringValue
                Defaults[.isLoggedIn] = true
                self.Log.debug("Login success")
                onLoginResult(nil)
            case .failure(let error):
                self.Log.error("Error fetching access token \(error)")
                onLoginResult(error)
            }

        }
    }

    func refresh() {
        let parameters = [
            "refresh_token": Defaults[.refreshToken],
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type": "refresh_token",
        ]

        Alamofire.request(tokenUrl, method: .post, parameters: parameters).responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let err = json["error"].string {
                    self.Log.debug("\(err): \(json["error_description"].string ?? "No error msg provided")")
                    return
                }
                let tokenExpiration = Date(timeInterval: TimeInterval(json["expires_in"].int!), since: Date())
                Defaults[.tokenExpirationDate] = tokenExpiration
                Defaults[.accessToken] = json["access_token"].stringValue
                self.Log.debug("Refresh token success")
            case .failure(let error):
                self.Log.error("Error refreshing token: \(error)")
            }
        }
    }

    func refreshTokenIfNecessary() {
        Log.info("Checking if token needs to be refreshed")
        if var date = Defaults[.tokenExpirationDate] {
            date.addTimeInterval(60 * 5) //refresh token with 5 mins left
            if date < Date() && Defaults[.isLoggedIn] {
                refresh()
            }
        }
    }

    func logout() {
        Defaults[.isLoggedIn] = false
        Defaults[.accessToken] = ""
        Defaults[.refreshToken] = ""
    }

}
