//
//  Authenticator.swift
//  MacAssistant
//
//  Created by Vansh on 5/3/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.

import Foundation
import Cocoa
import Alamofire
import SwiftyJSON

public class Authenticator {
    private let scope = "https://www.googleapis.com/auth/assistant-sdk-prototype"
    private var authUrl: String
    private var tokenUrl: String
    private var redirectUrl: String
    private var clientId: String
    private var clientSecret: String
    public var loginUrl: String
    private let defaults = UserDefaults.standard
    
    init() {
        let url = Bundle.main.url(forResource: "google_oauth", withExtension: "json")
        let json = try! JSON(data: Data(contentsOf: url!))["installed"]
        authUrl = json["auth_uri"].stringValue
        tokenUrl = json["token_uri"].stringValue
        redirectUrl = json["redirect_uris"][1].stringValue // Get the "http://localhost url
        clientId = json["client_id"].stringValue
        clientSecret = json["client_secret"].stringValue
        loginUrl = "\(authUrl)?client_id=\(clientId)&scope=\(scope)&response_type=code&redirect_uri=\(redirectUrl)"
    }
    
    func authenticate(code: String) {
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
                let expiresIn = Date(timeInterval: TimeInterval(json["expires_in"].int!), since: Date())
                self.defaults.set(expiresIn, forKey: Constants.EXPIRES_IN_KEY)
                self.defaults.set(json["access_token"].string, forKey: Constants.AUTH_TOKEN_KEY)
                self.defaults.set(json["refresh_token"].string, forKey: Constants.REFRESH_TOKEN_KEY)
                self.defaults.set(true, forKey: Constants.LOGGED_IN_KEY)
            case .failure(let error):
                print(error)
                
            }
            
        }
    }
    
    func refresh(onRefresh: @escaping ((Bool)->Void)) {
        let parameters = [
            "refresh_token": UserDefaults.standard.string(forKey: Constants.REFRESH_TOKEN_KEY)!,
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type": "refresh_token",
        ]
        
        Alamofire.request(tokenUrl, method: .post, parameters: parameters).responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let expiresIn = Date(timeInterval: TimeInterval(json["expires_in"].int!), since: Date())
                UserDefaults.standard.set(expiresIn, forKey: Constants.EXPIRES_IN_KEY)
                UserDefaults.standard.set(json["access_token"].string, forKey: Constants.AUTH_TOKEN_KEY)
                onRefresh(true)
            case .failure(let error):
                print(error)
                onRefresh(false)
            }
        }
    }
    
    func refreshTokenIfNecessary(_ completion: @escaping ((Bool)->Void)) {
        var date = defaults.object(forKey: Constants.EXPIRES_IN_KEY) as? Date
        date?.addTimeInterval(60*20) //refresh token with 20 mins left
        let isLoggedIn = defaults.bool(forKey: Constants.LOGGED_IN_KEY)
        if isLoggedIn && (date ?? Date()) < Date() {
            refresh(onRefresh: completion)
        } else {
            completion(isLoggedIn)
        }
        
    }
    
    func logout() {
        defaults.set(false, forKey: Constants.LOGGED_IN_KEY)
    }
    
}
