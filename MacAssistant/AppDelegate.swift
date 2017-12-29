//
//  AppDelegate.swift
//  MacAssistant
//
//  Created by Vansh on 4/27/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Cocoa
import gRPC
import Magnet
import AVFoundation
import Log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechRecognizerDelegate {
    
    let Log = Logger()
    
    lazy var loadingViewController = NSViewController(nibName: NSNib.Name(rawValue: "LoadingView"), bundle: nil)
    lazy var assistantViewController = AssistantViewController(nibName: NSNib.Name(rawValue: "AssistantView"), bundle: nil)
    lazy var loginViewController = LoginViewController(nibName: NSNib.Name(rawValue: "LoginView"), bundle: nil)
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    let userDefaults = UserDefaults.standard
    let authenticator = Authenticator()
    
    var isLoggedIn: Bool {
        get { return userDefaults.bool(forKey: Constants.LOGGED_IN_KEY) }
        set { userDefaults.set(newValue, forKey: Constants.LOGGED_IN_KEY) }
    }
    
    internal func applicationWillFinishLaunching(_ notification: Notification) {
        popover.contentViewController = loadingViewController
        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        userDefaults.synchronize()
        userDefaults.addObserver(self, forKeyPath: Constants.LOGGED_IN_KEY, options: NSKeyValueObservingOptions.new, context: nil)
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.authenticator.refreshTokenIfNecessary() { self.setAppropriateViewController(forLoginStatus: $0) }
        }.fire()
    }

    internal func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true
        statusItem.image = icon
        statusItem.action = #selector(statusIconClicked)
        registerHotkey()
        setupHotword(false) // Hotword activation
    }
    
    func registerHotkey() {
        Log.info("Registering hotkey")
        guard let keyCombo = KeyCombo(doubledCocoaModifiers: .command) else { return }
        let hotKey = HotKey(identifier: "CommandDoubleTapped",
                             keyCombo: keyCombo,
                             target: self,
                             action: #selector(AppDelegate.hotkeyPressed))
         hotKey.register() 
    }
    
    func setupHotword(_ enable: Bool = true) {
        if enable {
            let hotwordDetector = NSSpeechRecognizer()
            hotwordDetector?.commands = ["okay mac"]
            hotwordDetector?.blocksOtherRecognizers = true
            hotwordDetector?.listensInForegroundOnly = false
            hotwordDetector?.delegate = self
            hotwordDetector?.startListening()
        }
    }
    
    @objc func hotkeyPressed(sender: AnyObject?) {
        Log.info("Hotkey pressed")
        if !popover.isShown {
            showPopover(sender: sender)
            if isLoggedIn {
                (popover.contentViewController as? AssistantViewController)?.startListening()
            }
        } else if let controller = popover.contentViewController as? AssistantViewController {
            if isLoggedIn {
                if controller.isListening {
                    controller.stopListening()
                } else {
                    controller.startListening()
                }
            }
        }
    }
    
    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        if !popover.isShown {
            showPopover(sender: sender)
        }
        if isLoggedIn, let controller = popover.contentViewController as? AssistantViewController {
            if !controller.isListening {
                controller.startListening()
            }
        }
    }
    
    @objc func statusIconClicked(sender: AnyObject?) {
        togglePopover(sender: sender)
    }
    
    func showPopover(sender: AnyObject?) {
        Log.info("Showing popover")
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        Log.info("Closing popover")
        if let controller = popover.contentViewController as? AssistantViewController {
            controller.stopListening()
        }
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.isShown { closePopover(sender: sender) }
        else { showPopover(sender: sender) }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }

    // Observing the loggedIn key value pair
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let loggedIn = change?[.newKey] as? Bool {
            setAppropriateViewController(forLoginStatus: loggedIn)
            if !loggedIn {
                self.Log.info("Removing tokens from UserDefaults")
                userDefaults.removeObject(forKey: Constants.AUTH_TOKEN_KEY)
                userDefaults.removeObject(forKey: Constants.REFRESH_TOKEN_KEY)
                userDefaults.removeObject(forKey: Constants.EXPIRES_IN_KEY)
            }
        }
    }
    
    func setAppropriateViewController(forLoginStatus loggedIn: Bool) {
        popover.contentViewController = loggedIn ?
            assistantViewController :
            loginViewController
    }
}
