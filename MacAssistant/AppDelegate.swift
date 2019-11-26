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
import Preferences
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, LoginSuccessDelegate {

    let Log = Logger()
    let assistant = Assistant()
    var audioEngine: AudioEngine!
    var streamCall: AssistCall!
    let authenticator = Authenticator.instance
    let hotKey = HotKey(key: .space, modifiers: [.command, .shift])
    let sb = NSStoryboard(name: "Main", bundle: nil)
    let assitantWindowControllerID = "AssistantWindowControllerID"
    let loginWindowControllerID = "LoginWindowControllerID"
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    lazy var awc = sb.instantiateController(withIdentifier: assitantWindowControllerID) as! AssistantWindowController
    lazy var avc = sb.instantiateController(withIdentifier: "AssistantViewControllerID") as! AssistantViewController
    lazy var lwc = sb.instantiateController(withIdentifier: loginWindowControllerID) as! LoginWindowController
    
    lazy var preferencesWindowController = PreferencesWindowController(viewControllers: [
            GeneralPreferenceViewController(),
            AppearancePreferenceViewController(),
            AudioPreferenceViewController(),
            AccountPreferenceViewController()
    ])

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.image = #imageLiteral(resourceName: "statusIcon")
        statusItem.action = #selector(toggleWindow)
        showAppropriateWindow()
        hotKey.keyDownHandler = {
            self.showAppropriateWindow()
            self.avc.onMicClicked();
            
        }

//        preferencesWindowController.showWindow()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    @objc func toggleWindow() {
        if awc.window?.isVisible ?? false || lwc.window?.isVisible ?? false {
            hideAppropriateWindow()
        } else {
            showAppropriateWindow()
        }
    }
    
    func showAppropriateWindow() {
        if Defaults[.isLoggedIn] {
            showAssistant()
        } else {
            showLogin()
        }
    }
    
    func hideAppropriateWindow() {
        if awc.window?.isVisible ?? false {
            awc.close()
        }
        
        if lwc.window?.isVisible ?? false {
            lwc.close()
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
