//
//  AppDelegate.swift
//  MacAssistant
//
//  Created by Vansh on 4/27/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Cocoa
import OAuthSwift
import gRPC
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    
    private var isLoggedIn = true

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true
        statusItem.image = icon
        statusItem.action = #selector(statusIconClicked)
        gRPC.initialize()
        popover.contentViewController = AssistantViewController(nibName: "AssistantView", bundle: nil)
        NSAppleEventManager.shared().setEventHandler(self, andSelector:#selector(AppDelegate.handleGetURL(event:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        registerHotkey()
    }
    
    func registerHotkey() {
        guard let keyCombo = KeyCombo(doubledCocoaModifiers: .shift) else { return }
        let hotKey = HotKey(identifier: "ShiftDobuleTap",
                             keyCombo: keyCombo,
                             target: self,
                             action: #selector(AppDelegate.doubleTappedShiftKey))
        hotKey.register()
    }
    
    func doubleTappedShiftKey(sender: AnyObject?) {
        if (isLoggedIn) {
            if (!popover.isShown) {
                showPopover(sender: sender)
            } else {
                // TODO: Activate the mic in already present window
            }
        } else {
            // TODO: begin login process
        }
    }
    
    func handleGetURL(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor!) {
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue, let url = URL(string: urlString) {
            OAuthSwift.handle(url: url)
        }
    }
    
    func statusIconClicked(sender: AnyObject?) {
        print("Status Icon Clicked")
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
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // We don't call shutdown() here because we can't be sure that
        // any running server queues will have stopped by the time this is
        // called. If one is still running after we call shutdown(), the
        // program will crash.
        // gRPC.shutdown()
        HotKeyCenter.shared.unregisterAll()
    }


}

