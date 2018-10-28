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
    
    let sb = NSStoryboard(name: "Main", bundle: nil)
    let assitantWindowControllerID = "AssistantWindowControllerID"
    let loginWindowControllerID = "LoginWindowControllerID"
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    lazy var awc = sb.instantiateController(withIdentifier: assitantWindowControllerID) as! AssistantWindowController
    lazy var lwc = sb.instantiateController(withIdentifier: loginWindowControllerID) as! LoginWindowController

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
        awc.showWindow(nil)
    }
    
    func showLogin() {
        let lvc = lwc.contentViewController as! LoginViewController
        lvc.loginSuccessDelegate = self
        lwc.showWindow(nil)
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
