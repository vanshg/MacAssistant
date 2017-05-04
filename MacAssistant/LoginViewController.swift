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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: Authenticator.loginUrl)!))
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
            if url.hasPrefix("http://localhost") {
                decisionHandler(.cancel)
                print("Intercepted URL is \(url)")
                if let index = url.characters.index(of: "=") {
                    let code = url.substring(from: url.index(index, offsetBy: 1))
                    print("Got code \(code)")
                    Authenticator.authenticate(code: code)
                }
                // http://localhost/?code=4/o6Re_Db5RSsjlaTdB-NPbUrk9Q7JHN9HED0h6cNftJM#
                return
            }
        }
        decisionHandler(.allow)
    }

//    func webView(webView: WKWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: WKWebViewConfiguration) -> Bool {
//        
//    }

}

