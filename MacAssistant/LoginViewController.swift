//
//  LoginViewController.swift
//  MacAssistant
//
//  Created by Vansh on 4/27/17.
//  Copyright © 2017 vanshgandhi. All rights reserved.
//

import Cocoa
import WebKit

class LoginViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    private let authenticator = Authenticator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLoginUrl()
        webView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
            if url.hasPrefix("http://localhost") { // TODO: Un-hardcode this
                decisionHandler(.cancel)
                if let index = url.characters.index(of: "=") {
                    let code = url.substring(from: url.index(index, offsetBy: 1))
                    authenticator.authenticate(code: code)
                }
                loadLoginUrl() // To reset the WebView if user later logs out
                
                // TODO: Completely dismiss this viewcontroller on authentication
                
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func loadLoginUrl() {
        webView.load(URLRequest(url: URL(string: authenticator.loginUrl)!))
    }
}

