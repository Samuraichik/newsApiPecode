//
//  WebViewController.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 15.06.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
 
    public var articleUrl: String?

    
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: articleUrl ?? "Google.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
}
