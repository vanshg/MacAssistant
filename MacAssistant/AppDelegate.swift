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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechRecognizerDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    let userDefaults = UserDefaults.standard
    let authenticator = Authenticator()
    var isLoggedIn: Bool {
        get { return userDefaults.bool(forKey: Constants.LOGGED_IN_KEY) }
        set { userDefaults.set(newValue, forKey: Constants.LOGGED_IN_KEY) }
    }

    internal func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true
        statusItem.image = icon
        statusItem.action = #selector(statusIconClicked)
        popover.contentViewController = NSViewController(nibName: "LoadingView", bundle: nil)
        if isLoggedIn {
            let date = userDefaults.object(forKey: Constants.EXPIRES_IN_KEY) as? Date
            if (date ?? Date()) < Date() {
                authenticator.refresh() { success in
                    if success {
                        self.popover.contentViewController = AssistantViewController(nibName: "AssistantView", bundle: nil)
                    }
                }
            } else {
                popover.contentViewController = AssistantViewController(nibName: "AssistantView", bundle: nil)
            }
        } else {
            popover.contentViewController = LoginViewController(nibName: "LoginView", bundle: nil)
        }
        registerHotkey()
        setupHotword(false) // Hotword activation
    }
    
    func notifyLoggedIn() {
        let controller = AssistantViewController(nibName: "AssistantView", bundle: nil)
        popover.contentViewController = controller
    }
    
    func registerHotkey() {
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
    
    func hotkeyPressed(sender: AnyObject?) {
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
    
    func statusIconClicked(sender: AnyObject?) {
        togglePopover(sender: sender)
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
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
}
