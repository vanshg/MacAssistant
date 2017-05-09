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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    let userDefaults = UserDefaults.standard
    let authenticator = Authenticator()
    var isLoggedIn: Bool {
        get { return userDefaults.bool(forKey: Constants.LOGGED_IN_KEY) }
        set { userDefaults.set(newValue, forKey: Constants.LOGGED_IN_KEY) }
    }
    
    public override init() {
        super.init()
        popover.contentViewController = NSViewController(nibName: "LoadingView", bundle: nil)
//        popover.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        registerHotkey()
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
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
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true
        statusItem.image = icon
        statusItem.action = #selector(statusIconClicked)
    }
    
    func notifyLoggedIn() {
        let controller = AssistantViewController(nibName: "AssistantView", bundle: nil)
        popover.contentViewController = controller
    }
    
    func registerHotkey() {
        guard let keyCombo = KeyCombo(doubledCocoaModifiers: .control) else { return }
        let hotKey = HotKey(identifier: "ControlDoubleTap",
                             keyCombo: keyCombo,
                             target: self,
                             action: #selector(AppDelegate.hotkeyPressed))
        hotKey.register()
    }
    
    func hotkeyPressed(sender: AnyObject?) {
        if (!popover.isShown) {
            showPopover(sender: sender)
        }
        
        if (isLoggedIn) {
            (popover.contentViewController as? AssistantViewController)?.startListening()
        }
    }
    
    func statusIconClicked(sender: AnyObject?) {
        togglePopover(sender: sender)
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
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
