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
        webView.load(URLRequest(url: URL(string: authenticator.loginUrl)!))
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
                return
            }
        }
        decisionHandler(.allow)
    }

//    func webView(webView: WKWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: WKWebViewConfiguration) -> Bool {
//        
//    }

}

