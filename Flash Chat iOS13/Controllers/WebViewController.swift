//
//  WebViewController.swift
//  Flash Chat iOS13
//
//  Created by Denis Aleksandrov on 10/27/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wkUserContentController = WKUserContentController()
        
        wkUserContentController.add(self, name: "test")
        
        let internalScriptSource = "document.body.style.backgroundColor = `red`;"
        
        guard let scriptPath = Bundle.main.path(forResource: "Talk", ofType: "js"),
              let externalScriptSource = try? String(contentsOfFile: scriptPath) else { return }
        
        let wkUserScript = WKUserScript(source: externalScriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        wkUserContentController.addUserScript(wkUserScript)
        
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = wkUserContentController
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        
        view.addSubview(webView)
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        if let url = URL(string: "https://www.google.com") {
            webView.load(URLRequest(url: url))
        }
    }
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "test", let messageBody = message.body as? String {
            print("WKScriptMessageHandler: " + messageBody)
        }
        
//        if message.name == "test", let messageBody = message.body as? [String: Any], let age = messageBody["age"] as? Int {
//            print("Age in dog years: \(age * 15)")
//        }
    }
}
