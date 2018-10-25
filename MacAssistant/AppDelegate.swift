//
//  AppDelegate.swift
//  MacAssistant
//
//  Created by Vansh Gandhi on 7/25/18.
//  Copyright © 2018 Vansh Gandhi. All rights reserved.
//

import Cocoa
import AudioKit
import SwiftGRPC
import Log
import AudioKit
import SwiftyUserDefaults

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, LoginSuccessDelegate {

    let Log = Logger()
    let assistant = Assistant()
    var audioEngine: AudioEngine!
    var streamCall: AssistCall!
    let authenticator = Authenticator.instance
    
    let sb = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    let assitantWindowControllerID = NSStoryboard.SceneIdentifier(rawValue: "AssistantWindowControllerID")
    let loginWindowControllerID = NSStoryboard.SceneIdentifier(rawValue: "LoginWindowControllerID")
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var awc: AssistantWindowController!
    var created = false


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.image = #imageLiteral(resourceName: "statusIcon")
        statusItem.action = #selector(showAppropriateWindow)
        showAppropriateWindow()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    @objc func showAppropriateWindow() {
        if Defaults[.isLoggedIn] {
            showAssistant()
        } else {
            showLogin()
        }
    }
    
    func showAssistant() {
        if !created{
            awc = sb.instantiateController(withIdentifier: assitantWindowControllerID) as! AssistantWindowController
            created = true
        }
        awc.showWindow(nil)
    }
    
    func showLogin() {
        let lwc = sb.instantiateController(withIdentifier: loginWindowControllerID) as? LoginWindowController
        let lvc = lwc?.contentViewController as? LoginViewController
        lvc?.loginSuccessDelegate = self
        lwc?.showWindow(nil)
    }
    
    func onLoginSuccess() {
        Log.debug("login success")
        showAppropriateWindow()
    }
    
    func logout() {
        self.Log.info("Logging out")
        authenticator.logout()
    }
}
