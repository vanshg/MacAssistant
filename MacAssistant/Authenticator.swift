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
    static let authUrl = "https://accounts.google.com/o/oauth2/auth"
    static let tokenUrl = "https://accounts.google.com/o/oauth2/token"
    static let redirectUrl = "http://localhost"
    static let scope = "https://www.googleapis.com/auth/assistant-sdk-prototype"
    static let clientId = "35836793968-eosn0h38hk2rf3sjn9cpdunsj6vb2me2.apps.googleusercontent.com"
    static let clientSecret = "yrbbkUsBdzAeEidrdJieJll6"
    static let loginUrl = "\(authUrl)?client_id=\(clientId)&scope=\(scope)&response_type=code&redirect_uri=\(redirectUrl)"
    
    init() {
        
    }
    
    static func authenticate(code: String) {
        let parameters = [
            "code": code,
            "client_id": clientId,
            "client_secret": clientSecret,
            "redirect_uri": redirectUrl,
            "grant_type": "authorization_code",
        ]
        
        Alamofire.request(tokenUrl, method: .post, parameters: parameters).responseJSON() { response in
            print("Doing OAuth2 initial request")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let expiresIn = Date(timeInterval: TimeInterval(json["expires_in"].int!), since: Date())
                UserDefaults.standard.set(expiresIn, forKey: Constants.EXPIRES_IN_KEY)
                UserDefaults.standard.set(json["access_token"].string, forKey: Constants.AUTH_TOKEN_KEY)
                UserDefaults.standard.set(json["refresh_token"].string, forKey: Constants.REFRESH_TOKEN_KEY)
                UserDefaults.standard.set(true, forKey: Constants.LOGGED_IN_KEY)
                DispatchQueue.main.async {
                    (NSApp.delegate as? AppDelegate)?.notifyLoggedIn();
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func refresh(onRefresh: @escaping ((Bool)->Void)) {
        let parameters = [
            "refresh_token": UserDefaults.standard.string(forKey: Constants.REFRESH_TOKEN_KEY)!,
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type": "refresh_token",
        ]
        
        Alamofire.request(tokenUrl, method: .post, parameters: parameters).responseJSON() { response in
            print("Refreshing token")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("Got refreshed access token: \(json["access_token"].string!)")
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
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: Constants.AUTH_TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.REFRESH_TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.EXPIRES_IN_KEY)
        UserDefaults.standard.removeObject(forKey: Constants.LOGGED_IN_KEY)
    }
    
}
